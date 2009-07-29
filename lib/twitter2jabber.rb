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

require 'rubygems'
require 'twitter'
require 'xmpp4r-simple'

require 'twitter2jabber/version'

class Twitter2Jabber

  DEFAULT_PAUSE = 60

  def self.loop(options, recipients = [], pause = nil, &block)
    new(options).loop(recipients, pause, &block)
  end

  def self.run(options, recipients = [], &block)
    new(options).run(recipients, &block)
  end

  attr_reader :twitter, :jabber, :filter

  def initialize(options, &block)
    [:twitter, :jabber].each { |client|
      raise ArgumentError, "#{client} config missing" unless options[client].is_a?(Hash)
    }

    @twitter = twitter_connect(options[:twitter])
    @jabber  = jabber_connect(options[:jabber])

    @filter = options[:filter] || block
  end

  def run(recipients = [], seen = {}, &block)
    deliver_tweets(recipients, seen, &block)
    post_messages
  end

  def loop(recipients = [], pause = nil, &block)
    pause ||= DEFAULT_PAUSE

    seen = Hash.new { |h, k| h[k] = true; false }

    Kernel.loop {
      run(recipients, seen, &block)

      sleep pause
    }
  end

  def deliver_tweets(recipients, seen = {}, &block)
    get_tweets.each { |tweet|
      next if seen[tweet.id]

      # apply filters
      next if filter && !filter[tweet]
      next if block  && !block[tweet]

      msg = format_tweet(tweet)

      recipients.each { |recipient|
        jabber.deliver(recipient, msg)
      }

      sleep 1
    }
  rescue Twitter::CantConnect
    sleep pause
    retry
  end

  def post_messages
    jabber.received_messages { |msg|
      twitter.update(msg.body) if msg.type == :chat
    }
  end

  private

  def twitter_connect(options)
    auth   = Twitter::HTTPAuth.new(options[:user], options[:pass])
    client = Twitter::Base.new(auth)

    # verify credentials
    client.verify_credentials
    client
  rescue Twitter::TwitterError => err
    raise "Can't connect to Twitter with ID '#{options[:user]}': #{err}"
  end

  def jabber_connect(options)
    Jabber::Simple.new(options[:user], options[:pass])
  rescue Jabber::JabberError => err
    raise "Can't connect to Jabber with JID '#{options[:user]}': #{err}"
  end

  def get_tweets
    twitter.friends_timeline.sort_by { |tweet|
      Time.parse(tweet.created_at)
    }
  end

  def format_tweet(tweet)
    "#{tweet.user.name} [#{tweet.created_at}]:\n\n#{tweet.text}"
  end

end
