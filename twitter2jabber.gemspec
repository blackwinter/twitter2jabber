# -*- encoding: utf-8 -*-
# stub: twitter2jabber 0.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "twitter2jabber"
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2014-04-25"
  s.description = "Read Twitter streams through Jabber."
  s.email = "jens.wille@gmail.com"
  s.executables = ["twitter2jabber"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "TODO", "bin/twitter2jabber", "example/config.yaml", "example/templates/tweet.html", "example/templates/tweet.txt", "lib/twitter2jabber.rb", "lib/twitter2jabber/cli.rb", "lib/twitter2jabber/jabber_client.rb", "lib/twitter2jabber/twitter_client.rb", "lib/twitter2jabber/version.rb"]
  s.homepage = "http://github.com/blackwinter/twitter2jabber"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\ntwitter2jabber-0.8.1 [2014-04-25]:\n\n* Exhaust the Twitter stream by buffering all tweets received since the last\n  time, or one batch when run for the first time.\n* Relies on the order in Twitter::REST::Client#home_timeline (descending by\n  ID).\n* Disconnects Twitter and Jabber clients when finished.\n\n"
  s.rdoc_options = ["--title", "twitter2jabber Application documentation (v0.8.1)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2.x"
  s.summary = "Twitter-to-Jabber gateway."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cyclops>, [">= 0"])
      s.add_runtime_dependency(%q<longurl>, [">= 0"])
      s.add_runtime_dependency(%q<xmpp4r>, [">= 0"])
      s.add_runtime_dependency(%q<twitter>, [">= 5.0"])
      s.add_development_dependency(%q<hen>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<cyclops>, [">= 0"])
      s.add_dependency(%q<longurl>, [">= 0"])
      s.add_dependency(%q<xmpp4r>, [">= 0"])
      s.add_dependency(%q<twitter>, [">= 5.0"])
      s.add_dependency(%q<hen>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<cyclops>, [">= 0"])
    s.add_dependency(%q<longurl>, [">= 0"])
    s.add_dependency(%q<xmpp4r>, [">= 0"])
    s.add_dependency(%q<twitter>, [">= 5.0"])
    s.add_dependency(%q<hen>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
