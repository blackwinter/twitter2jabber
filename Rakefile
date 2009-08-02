require %q{lib/twitter2jabber/version}

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project  => %q{twitter2jabber},
      :package  => %q{twitter2jabber},
      :rdoc_dir => nil
    },

    :gem => {
      :version      => Twitter2Jabber::VERSION,
      :summary      => %q{Twitter-to-Jabber gateway.},
      :homepage     => %q{http://twitter2jabber.rubyforge.org/},
      :files        => FileList['lib/**/*.rb', 'bin/*'].to_a,
      :extra_files  => FileList['[A-Z]*', 'sample/**/*'].to_a,
      :dependencies => %w[twitter xmpp4r-simple highline]
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
end

### Place your custom Rake tasks here.
