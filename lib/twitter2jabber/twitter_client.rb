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

require 'twitter'
require 'longurl'

class Twitter2Jabber

  class TwitterClient

    MAX_COUNT = 200

    def initialize(gw, config)
      @gw, @config, @client = gw, config, Twitter::REST::Client.new(
        consumer_key:        @spec = config[:consumer_token],
        consumer_secret:     config[:consumer_secret],
        access_token:        config[:access_token],
        access_token_secret: config[:access_secret]
      )
    end

    attr_reader :config, :spec, :client

    def connect
      client.verify_credentials
      log 'connected'
    rescue Twitter::Error => err
      raise "Can't connect to Twitter with ID '#{spec}': #{err}"
    end

    def disconnect
      @client = nil
      log 'disconnected'
    end

    def tweets(since_id = nil)
      tweets = client.home_timeline(since_id: since_id, count: MAX_COUNT)
      return unless tweets.is_a?(Array)

      tweets.sort_by { |tweet| tweet.created_at }.each { |tweet|
        log since_id = tweet.id
        yield tweet
        sleep 1
      }

      since_id
    rescue Twitter::Error, Timeout::Error
    rescue => err
      warn "#{err} (#{err.class})"
    end

    def process_message(text)
      text.gsub(%r{https?://\S+}) { |match| LongURL.expand(match) rescue match }
    end

    def process_html(text)
      text.gsub(/(?:\A|\W)@(\w+)/, '@<a href="https://twitter.com/\1">\1</a>')
          .gsub(/(?:\A|\W)#(\w+)/, '<a href="https://search.twitter.com/search?q=%23\1">#\1</a>')
    end

    def process_text(text)
      text
    end

    private

    def log(msg)
      @gw.log("TWITTER #{msg}")
    end

  end

end
