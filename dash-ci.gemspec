# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dash-ci}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima"]
  s.date = %q{2009-03-06}
  s.files = [
    "lib/dash-ci.rb",
    "lib/dash-ci",
    "lib/dash-ci/base.rb",
    "lib/dash-ci/target.rb",
    "lib/dash-ci/session.rb",
  ]
  s.require_paths = ["lib", "lib/dash-ci"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{CI metrics for Dash.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fiveruns-dash-ruby>, [">= 0"])
    else
      s.add_dependency(%q<fiveruns-dash-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<fiveruns-dash-ruby>, [">= 0"])
  end
end
