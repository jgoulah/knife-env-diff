# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-env-diff/version"

Gem::Specification.new do |s|
  s.name          = 'knife-env-diff'
  s.version       = Knife::EnvironmentDiff::VERSION
  s.date          = '2012-01-02'
  s.summary       = "A plugin for Chef::Knife which displays the roles that are included recursively within a role and optionally displays all the roles that include it."
  s.description   = s.summary
  s.authors       = ["John Goulah"]
  s.email         = ["jgoulah@gmail.com"]
  s.homepage      = "https://github.com/jgoulah/knife-env-diff"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
