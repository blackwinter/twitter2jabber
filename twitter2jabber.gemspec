# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twitter2jabber}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jens Wille}]
  s.date = %q{2011-07-29}
  s.description = %q{Twitter-to-Jabber gateway.}
  s.email = %q{ww@blackwinter.de}
  s.executables = [%q{twitter2jabber}]
  s.extra_rdoc_files = [%q{README}, %q{COPYING}, %q{ChangeLog}]
  s.files = [%q{lib/twitter2jabber.rb}, %q{lib/twitter2jabber/version.rb}, %q{bin/twitter2jabber}, %q{README}, %q{ChangeLog}, %q{Rakefile}, %q{TODO}, %q{COPYING}, %q{example/templates/tweet.txt}, %q{example/templates/tweet.html}, %q{example/config.yaml}]
  s.homepage = %q{http://twitter2jabber.rubyforge.org/}
  s.rdoc_options = [%q{--all}, %q{--main}, %q{README}, %q{--charset}, %q{UTF-8}, %q{--title}, %q{twitter2jabber Application documentation (v0.5.0)}, %q{--line-numbers}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{twitter2jabber}
  s.rubygems_version = %q{1.8.6}
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
