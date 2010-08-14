# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{twitter2jabber}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2010-08-14}
  s.default_executable = %q{twitter2jabber}
  s.description = %q{Twitter-to-Jabber gateway.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.executables = ["twitter2jabber"]
  s.extra_rdoc_files = ["COPYING", "ChangeLog", "README"]
  s.files = ["lib/twitter2jabber.rb", "lib/twitter2jabber/version.rb", "bin/twitter2jabber", "COPYING", "Rakefile", "README", "ChangeLog", "TODO", "sample/config.yaml", "sample/templates", "sample/templates/tweet.html", "sample/templates/tweet.txt"]
  s.homepage = %q{http://twitter2jabber.rubyforge.org/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--charset", "UTF-8", "--main", "README", "--title", "twitter2jabber Application documentation", "--all"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{twitter2jabber}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Twitter-to-Jabber gateway.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
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
