# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "twitter2jabber"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2012-09-20"
  s.description = "Twitter-to-Jabber gateway."
  s.email = "ww@blackwinter.de"
  s.executables = ["twitter2jabber"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/twitter2jabber/version.rb", "lib/twitter2jabber.rb", "bin/twitter2jabber", "COPYING", "TODO", "ChangeLog", "Rakefile", "README", "example/config.yaml", "example/templates/tweet.html", "example/templates/tweet.txt"]
  s.homepage = "http://twitter2jabber.rubyforge.org/"
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "twitter2jabber Application documentation (v0.6.0)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "twitter2jabber"
  s.rubygems_version = "1.8.24"
  s.summary = "Twitter-to-Jabber gateway."

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
