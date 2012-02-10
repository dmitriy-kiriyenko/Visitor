# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "visitor/version"

Gem::Specification.new do |s|
  s.name        = "visitor"
  s.version     = Visitor::VERSION
  s.authors     = ["Dmitriy Kiriyenko, Maxim Tsaplin"]
  s.email       = ["dmitriy.kiriyenko@anahoret.com, maxim.tsaplin@anahoret.com"]
  s.homepage    = ""
  s.summary     = %q{Just an implementation of Visitor design patter in Ruby.}
  s.description = %q{Just an implementation of Visitor design patter in Ruby. As far as double dispatch is applicable for a language with dynamic typing.}

  s.rubyforge_project = "visitor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
