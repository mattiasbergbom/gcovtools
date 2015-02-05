require File.expand_path('../lib/version.rb', __FILE__)

Gem::Specification.new do |gem|

  gem.name        = 'gcovtools'
  gem.version     = GCOVTOOLS::VERSION
  gem.date        = '2014-12-09'
  gem.summary     = "gcov parser and formatter"
  gem.description = "gcovtools digests .gcov files generated by llvm-cov and translates them into various common formats"
  gem.authors     = ["Mattias Bergbom"]
  gem.email       = 'mattias.bergbom@gmail.com'
  gem.files       = `git ls-files`.split($\)
  gem.executables = ["gcovtools"]
  gem.homepage    = 'http://rubygems.org/gems/gcovtools'
  gem.license     = 'MIT'
  gem.required_ruby_version = '>= 2.0'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubygems-tasks'
  gem.add_development_dependency 'simplecov'
  
  gem.add_runtime_dependency 'terminal-table'
  gem.add_runtime_dependency 'term-ansicolor'
  gem.add_runtime_dependency 'thor'
  gem.add_runtime_dependency 'gyoku', '~> 1.0'

end
