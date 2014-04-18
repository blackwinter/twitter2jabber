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

class Twitter2Jabber

  class << self

    def run(options, since_id = nil)
      new(options).connect.deliver_tweets(since_id).disconnect
    end

    def client(client)
      const_get("#{client.to_s.capitalize}Client")
    end

  end

  def initialize(options)
    @twitter = initialize_client(:twitter, options)
    @jabber  = initialize_client(:jabber,  options)

    if @debug = options[:debug] or options[:verbose]
      @spec = "#{twitter.spec} -> #{jabber.spec}"

      @log = options[:log] || $stderr
      @log.sync = true

      require 'time'
    else
      define_singleton_method(:log) { |_| }
    end
  end

  attr_reader :twitter, :jabber, :debug

  def connect
    log 'Connecting...'

    twitter.connect
    jabber.connect

    self
  end

  def disconnect
    log 'Disconnecting...'

    twitter.disconnect
    jabber.disconnect

    self
  end

  def deliver_tweets(since_id = nil)
    twitter.tweets(since_id) { |tweet| jabber.deliver(tweet) }
    self
  end

  def log(msg)
    @log.puts "#{Time.now.xmlschema} [#{@spec}] #{msg}"
  end

  private

  def initialize_client(client, options)
    (config = options[client]).is_a?(Hash) ?
      self.class.client(client).new(self, config) :
      raise(ArgumentError, "#{client} config missing")
  end

end

require_relative 'twitter2jabber/version'
require_relative 'twitter2jabber/twitter_client'
require_relative 'twitter2jabber/jabber_client'
