# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'functional/version'

Gem::Specification.new do |s|
  s.name        = 'functional'
  s.version     = Functional::VERSION
  s.authors     = ['Jason Whittle']
  s.email       = ['jason.whittle@gmail.com']
  s.homepage    = 'https://github.com/whittle/functional'
  s.summary     = 'A collection of extensions for functional Ruby and Rails programming.'
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rspec-expectations'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'ruby-debug'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-rspec'

  # Used only for testing specific extensions.
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'sqlite3'
end
