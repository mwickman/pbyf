Gem::Specification.new do |s|
  s.name        = 'pbyf'
  s.version     = '0.0.4'
  s.date        = '2012-08-14'
  s.summary     = "A gem for use with Yahoo Finance"
  s.description = "Use this gem to pull data from the Yahoo Finance site, and do some basic calculations with it."
  s.authors     = ["Matt Wickman"]
  s.email       = 'wickman.matthew@gmail.com'
  s.files       = ["lib/pbyf.rb"]
  s.homepage    = 'http://github.com/mwickman/pbyf'
  s.add_dependency('rest-client')
end