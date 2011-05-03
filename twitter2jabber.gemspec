# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twitter2jabber}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2011-05-03}
  s.description = %q{Twitter-to-Jabber gateway.}
  s.email = %q{ww@blackwinter.de}
  s.executables = ["twitter2jabber"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/twitter2jabber.rb", "lib/twitter2jabber/version.rb", "bin/twitter2jabber", "README", "ChangeLog", "Rakefile", "TODO", "COPYING", "example/templates/tweet.txt", "example/templates/tweet.html", "example/config.yaml"]
  s.homepage = %q{http://twitter2jabber.rubyforge.org/}
  s.rdoc_options = ["--line-numbers", "--main", "README", "--charset", "UTF-8", "--all", "--title", "twitter2jabber Application documentation (v0.4.0)"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twitter2jabber}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Twitter-to-Jabber gateway.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<twitter>, [">= 0"])
      s.add_runtime_dependency(%q<xmpp4r-simple>, [">= 0"])
      s.add_runtime_dependency(%q<shorturl>, [">= 0"])
      s.add_runtime_dependency(%q<longurl>, [">= 0"])
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_runtime_dependency(%q<elif>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-nuggets>, [">= 0"])
    else
      s.add_dependency(%q<twitter>, [">= 0"])
      s.add_dependency(%q<xmpp4r-simple>, [">= 0"])
      s.add_dependency(%q<shorturl>, [">= 0"])
      s.add_dependency(%q<longurl>, [">= 0"])
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<elif>, [">= 0"])
      s.add_dependency(%q<ruby-nuggets>, [">= 0"])
    end
  else
    s.add_dependency(%q<twitter>, [">= 0"])
    s.add_dependency(%q<xmpp4r-simple>, [">= 0"])
    s.add_dependency(%q<shorturl>, [">= 0"])
    s.add_dependency(%q<longurl>, [">= 0"])
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<elif>, [">= 0"])
    s.add_dependency(%q<ruby-nuggets>, [">= 0"])
  end
end
