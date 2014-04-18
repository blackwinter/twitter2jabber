#--
###############################################################################
#                                                                             #
# twitter2jabber - Twitter-to-Jabber gateway.                                 #
#                                                                             #
# Copyright (C) 2009-2014 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# twitter2jabber is free software; you can redistribute it and/or modify it   #
# under the terms of the GNU Affero General Public License as published by    #
# the Free Software Foundation; either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# twitter2jabber is distributed in the hope that it will be useful, but       #
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public      #
# License for more details.                                                   #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with twitter2jabber. If not, see <http://www.gnu.org/licenses/>.      #
#                                                                             #
###############################################################################
#++

require 'erb'
require 'xmpp4r'

class Twitter2Jabber

  class JabberClient

    DEFAULT_TEMPLATES = File.expand_path('../../../example/templates', __FILE__)

    DEFAULT_FORMAT = 'txt'

    JABBER_NS = 'http://jabber.org/protocol/xhtml-im'
    XHTML_NS  = 'http://www.w3.org/1999/xhtml'

    def initialize(gw, config)
      @gw, @config, @spec = gw, config, config[:username]

      @format = config.fetch(:format, DEFAULT_FORMAT).to_s

      if File.readable?(template = File.expand_path(File.join(
        config[:templates] || DEFAULT_TEMPLATES, "tweet.#{@format}")))

        @erb = ERB.new(File.read(template))
      else
        raise ArgumentError, "format not supported: #{@format}"
      end
    end

    attr_reader :config, :spec

    def client
      @client ||= Jabber::Client.new(spec).tap { |client|
        client.connect
        client.auth(config[:password])
      }
    end

    def connect
      deliver(Jabber::Presence.new(nil, 'Available'), nil)
      log 'connected'
    rescue Jabber::JabberError, Errno::ETIMEDOUT => err
      raise "Can't connect to Jabber with JID '#{spec}': #{err}"
    end

    def format(tweet)
      user = tweet.user
      text = @erb.result(binding)

      msg = Jabber::Message.new.set_type(:chat)
      msg.add_element(format_element(text))
      msg
    end

    def deliver(msg, recipient = config[:recipient])
      msg = format(msg) unless msg.is_a?(Jabber::XMPPStanza)
      msg.to = Jabber::JID.new(recipient).strip if recipient

      @gw.debug ? log("#{recipient}: #{msg}") : send_msg(msg)
    rescue => err
      warn "#{err} (#{err.class})"
      retry if err.is_a?(Jabber::ServerDisconnected)
    end

    private

    # cf. <http://devblog.famundo.com/articles/2006/10/18/ruby-and-xmpp-jabber-part-3-adding-html-to-the-messages>
    def format_element(text)
      twitter = @gw.twitter

      text, body = twitter.process_message(text), REXML::Element.new('body')

      if @format == 'html'
        REXML::Text.new(twitter.process_html(text), false, body, true, nil, /.^/)

        html = REXML::Element.new('html').add_namespace(JABBER_NS)
        html.add(body.add_namespace(XHTML_NS))
        html
      else
        REXML::Text.new(twitter.process_text(text), true, body, true, nil, /.^/)
        body
      end
    end

    def send_msg(msg, attempts = 0)
      attempts += 1
      client.send(msg)
    rescue Errno::EPIPE, IOError
      raise if attempts > 3

      begin
        @client.close
      rescue Errno::EPIPE, IOError
      end

      @client = nil
      sleep 1
      retry
    end

    def log(msg)
      @gw.log("JABBER #{msg}")
    end

  end

end
