Gem::Specification.new do |s|
  s.name        = 'Virtual Attributes'
  s.version     = '0.0.1'
  s.date        = '2015-03-19'
  s.summary     = "Enhance ActiveRecord's Serialize with types attributes"
  s.description = "This gem allow you to add whenever columns you want to your model through one single serialized attribute"
  s.authors     = ["Ihcène Medjber"]
  s.email       = 'ihcene@aritylabs.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'
  s.add_runtime_dependency 'activerecord', '~> 4.3', '>= 3.0.0'
  s.add_development_dependency "rspec"
end