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

require 'cyclops'
require 'twitter2jabber'

class Twitter2Jabber

  class CLI < Cyclops

    class << self

      def defaults
        super.merge(
          config:   'config.yaml',
          since_id: nil,
          verbose:  false,
          debug:    false
        )
      end

      def extract_since_id(log)
        return unless File.readable?(log)

        id, re = nil, /\bTWITTER\s+(\d+)\Z/

        File.foreach(log) { |line|
          id = $1 if line =~ re
        }

        id.to_i if id
      end

    end

    def run(arguments)
      if log = options[:log]
        options[:log] = File.open(log, 'a')
        options[:since_id] ||= self.class.extract_since_id(log)
      end

      Twitter2Jabber.run(options, options.delete(:since_id))
    end

    private

    def parse_options(arguments)
      super

      options[:log] &&= File.expand_path(options[:log])

      t = options[:twitter] ||= {}
      t[:consumer_token]  ||= ask('Twitter consumer token: ')
      t[:consumer_secret] ||= askpass("Consumer secret for Twitter application #{t[:consumer_token]}: ")
      t[:access_token]    ||= ask('Twitter access token: ')
      t[:access_secret]   ||= askpass("Access secret for Twitter user #{t[:access_token]}: ")

      j = options[:jabber] ||= {}
      j[:username] ||= ask('Jabber ID: ')
      j[:password] ||= askpass("Password for Jabber ID #{j[:username]}: ")
    end

    def opts(opts)
      opts.option(:since_id__ID, Integer, 'Return tweets with status IDs greater than ID')

      opts.separator

      opts.option(:log__FILE, 'Path to log file [Default: STDERR]')
    end

    def debug_message
      "don't send any messages"
    end

  end

end
