#--
###############################################################################
#                                                                             #
# twitter2jabber - Twitter-to-Jabber gateway.                                 #
#                                                                             #
# Copyright (C) 2009 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <ww@blackwinter.de>                                          #
#                                                                             #
# twitter2jabber is free software; you can redistribute it and/or modify it   #
# under the terms of the GNU General Public License as published by the Free  #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# twitter2jabber is distributed in the hope that it will be useful, but       #
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with twitter2jabber. If not, see <http://www.gnu.org/licenses/>.            #
#                                                                             #
###############################################################################
#++

require 'time'
require 'erb'

require 'rubygems'
require 'twitter'
require 'xmpp4r-simple'

require 'twitter2jabber/version'

class Twitter2Jabber

  MAX_LENGTH = 140

  DEFAULT_PAUSE = 60

  DEFAULT_FORMATS = %w[txt]

  DEFAULT_TEMPLATES = File.expand_path(File.join(File.dirname(__FILE__), %w[.. sample templates]))

  JABBER_NS = 'http://jabber.org/protocol/xhtml-im'
  XHTML_NS  = 'http://www.w3.org/1999/xhtml'

  def self.loop(options, recipients = [], pause = nil, &block)
    new(options).loop(recipients, pause, &block)
  end

  def self.run(options, recipients = [], &block)
    new(options).run(recipients, &block)
  end

  attr_reader :id, :verbose, :debug, :twitter, :jabber, :filter, :formats, :templates

  def initialize(options, &block)
    [:twitter, :jabber].each { |client|
      raise ArgumentError, "#{client} config missing" unless options[client].is_a?(Hash)
    }

    @id = "#{options[:twitter][:user]} -> #{options[:jabber][:user]}"

    @verbose = options[:verbose]
    @debug   = options[:debug]

    @twitter = twitter_connect(options[:twitter])
    @jabber  = jabber_connect(options[:jabber])

    @filter  = options[:filter]  || block
    @formats = options[:formats] || DEFAULT_FORMATS

    @templates = Dir[
      File.join(options[:template_dir] || DEFAULT_TEMPLATES, 'tweet.*')
    ].inject({}) { |hash, template|
      hash.update(File.extname(template).sub(/\A\./, '') => File.read(template))
    }
  end

  def run(recipients = [], seen = {}, flag = true, &block)
    deliver_tweets(recipients, seen, &block) if flag
    post_messages
  end

  def loop(recipients = [], pause = nil, &block)
    pause ||= DEFAULT_PAUSE

    # jabber/twitter ratio
    ratio = 10
    pause /= ratio

    # sleep at least one second
    pause = 1 if pause < 1

    i, seen = 0, Hash.new { |h, k| h[k] = true; false }

    trap(:INT) { i = nil }

    while i
      i += 1

      run(recipients, seen, i % ratio == 1, &block)

      sleep pause
    end
  end

  def deliver_tweets(recipients, seen = {}, &block)
    get_tweets.each { |tweet|
      next if seen[tweet.id]

      logt tweet.id

      # apply filters
      next if filter && !filter[tweet]
      next if block  && !block[tweet]

      msg = format_tweet(tweet)

      recipients.each { |recipient|
        deliver(recipient, msg)
      }

      sleep 1
    }
  end

  def post_messages
    jabber.received_messages { |msg|
      next unless msg.type == :chat

      logj msg.id

      handle_command(msg.body, msg.from)
    }
  end

  private

  def twitter_connect(options)
    auth   = Twitter::HTTPAuth.new(options[:user], options[:pass])
    client = Twitter::Base.new(auth)

    # verify credentials
    client.verify_credentials

    logt "connected #{Time.now}"

    client
  rescue Twitter::TwitterError => err
    raise "Can't connect to Twitter with ID '#{options[:user]}': #{err}"
  end

  def jabber_connect(options)
    client = Jabber::Simple.new(options[:user], options[:pass])

    logj "connected #{Time.now}"

    client
  rescue Jabber::JabberError => err
    raise "Can't connect to Jabber with JID '#{options[:user]}': #{err}"
  end

  def get_tweets
    twitter.friends_timeline.sort_by { |tweet|
      tweet.created_at = Time.parse(tweet.created_at)
    }
  rescue Twitter::CantConnect
    sleep pause
    retry
  end

  def format_tweet(tweet)
    user = tweet.user

    msg = Jabber::Message.new.set_type(:chat)

    formats.each { |format|
      if template = templates[format]
        msg.add_element format_element(format) {
          ERB.new(template).result(binding)
        }
      end
    }

    msg
  end

  # cf. <http://devblog.famundo.com/articles/2006/10/18/ruby-and-xmpp-jabber-part-3-adding-html-to-the-messages>
  def format_element(format)
    body = REXML::Element.new('body')
    REXML::Text.new(yield, format != 'html', body, true, nil, /.^/)

    case format
      when 'html'
        html = REXML::Element.new('html').add_namespace(JABBER_NS)
        html.add(body.add_namespace(XHTML_NS))
        html
      else
        body
    end
  end

  def handle_command(body, from, execute = true)
    case body
      when /\Ahe?(?:lp)?\z/i
        deliver(from, <<-HELP) if execute
h[e[lp]]            -- Print this help

de[bug]             -- Print debug mode
de[bug] on|off      -- Turn debug mode on/off

bl[ock] #ID         -- Block ID
fa[v[orite]] #ID    -- Create favorite #ID

re[ply] #ID: ...    -- Reply to ID
le[n[gth]] ...      -- Determine length
...                 -- Update status

(Note: Message body must be shorter than #{MAX_LENGTH} characters)
        HELP
      when /\Ade(?:bug)?(?:\s+(on|off))?\z/i
        if execute
          flag = $1.downcase if $1

          case flag
            when 'on'
              @debug = true
            when 'off'
              @debug = false
          end

          deliver(from, "DEBUG = #{debug ? 'on' : 'off'}")
        end
      when /\Abl(?:ock)?\s+#?(\d+)\z/i
        twitter.block($1) if execute && !debug
      when /\Afav?(?:orite)?\s+#?(\d+)\z/i
        twitter.favorite_create($1) if execute && !debug
      else
        options = {}

        if execute && body.sub!(/\Alen?(?:gth)?\s+/i, '')
          if body = handle_command(body, from, false)
            length = body.length
            hint   = length <= MAX_LENGTH ? 'OK' : 'TOO LONG'

            deliver(from, "#{length} [#{hint}]: #{body}")
          end

          return
        end

        if body.sub!(/\Are(?:ply)?\s+#?(\d+):?\s+/i, '')
          options[:in_reply_to_status_id] = $1
        end

        return body unless execute

        if body.length <= MAX_LENGTH
          update(body, options)
        else
          deliver(from, "MSG TOO LONG (> #{MAX_LENGTH}): #{body}")
        end
    end
  end

  def deliver(recipient, msg)
    if debug
      logj "#{recipient}: #{msg}", true
      return
    end

    jabber.deliver(recipient, msg)
  end

  def update(msg, options = {})
    if debug
      logt "#{msg} (#{options.inspect})", true
      return
    end

    twitter.update(msg, options)
  end

  def log(msg, verbose = verbose)
    warn "[#{id}] #{msg}" if verbose
  end

  def logt(msg, verbose = verbose)
    log("TWITTER #{msg}", verbose)
  end

  def logj(msg, verbose = verbose)
    log("JABBER #{msg}", verbose)
  end

end
