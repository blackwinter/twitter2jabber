require_relative 'lib/twitter2jabber/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{twitter2jabber},
      version:      Twitter2Jabber::VERSION,
      summary:      %q{Twitter-to-Jabber gateway.},
      description:  %q{Read Twitter streams through Jabber.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: {
        cyclops: '~> 0.2',
        longurl: '~> 0.1',
        xmpp4r:  '~> 0.5',
        twitter: '~> 5.0'
      },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
