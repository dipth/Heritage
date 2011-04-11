# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heritage/version"

Gem::Specification.new do |s|
  s.name        = "heritage"
  s.version     = Heritage::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Dippel"]
  s.email       = ["thomasdi@benjamin.dk"]
  s.homepage    = "http://rubygems.org/gems/heritage"
  s.summary     = %q{A gem for implementing multiple table inheritance in rails 3}
  s.description = %q{A gem for implementing multiple table inheritance in rails 3}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
