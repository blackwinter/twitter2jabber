require File.expand_path(%q{../lib/twitter2jabber/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{twitter2jabber},
      :version      => Twitter2Jabber::VERSION,
      :summary      => %q{Twitter-to-Jabber gateway.},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@gmail.com},
      :homepage     => :blackwinter,
      :dependencies => %w[
        twitter xmpp4r-simple shorturl longurl
        highline elif ruby-nuggets
      ]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
