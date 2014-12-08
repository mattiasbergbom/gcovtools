Gem::Specification.new do |s|
  s.name        = 'gcov2x'
  s.version     = '0.0.1'
  s.date        = '2014-12-08'
  s.summary     = "gcov parser and formatter"
  s.description = "gcov2x digests .gcov files generated by llvm-cov and translates them into various common formats"
  s.authors     = ["Mattias Bergbom"]
  s.email       = 'mattias.bergbom@gmail.com'
  s.files       = ["lib/gcov2x.rb", "lib/project.rb", "lib/file.rb", "lib/line.rb"]
  s.homepage    = 
    'http://rubygems.org/gems/gcov2x'
  s.license       = 'MIT'
end
