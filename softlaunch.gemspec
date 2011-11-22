# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "softlaunch/version"

Gem::Specification.new do |s|
  s.name        = "softlaunch"
  s.version     = Softlaunch::VERSION
  s.authors     = ["Lee Atchison"]
  s.email       = ["lee@leeatchison.com"]
  s.homepage    = ""
  s.summary     = %q{Stage the launch of new features to smaller groups of people first.}
  s.description = %q{Stage the launch of new features to smaller groups of people first.}

  s.rubyforge_project = "softlaunch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
end
