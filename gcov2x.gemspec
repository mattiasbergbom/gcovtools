require File.expand_path('../lib/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'gcov2x'
  gem.version     = GCOV::VERSION
  gem.date        = '2014-12-09'
  gem.summary     = "gcov parser and formatter"
  gem.description = "gcov2x digests .gcov files generated by llvm-cov and translates them into various common formats"
  gem.authors     = ["Mattias Bergbom"]
  gem.email       = 'mattias.bergbom@gmail.com'
  gem.files       = `git ls-files`.split($\)
  gem.executables = ["gcov2x"]
  gem.homepage    = 'http://rubygems.org/gems/gcov2x'
  gem.license     = 'MIT'
end
