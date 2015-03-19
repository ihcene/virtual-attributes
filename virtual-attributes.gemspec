$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'virtual-attributes'
  s.version     = '0.1.1'
  s.date        = '2015-03-19'
  s.summary     = "Enhance ActiveRecord's Serialize with types attributes"
  s.description = "This gem allow you to add whenever columns you want to your model through one single serialized attribute"
  s.authors     = ["ihcene"]
  s.email       = 'ihcene@aritylabs.com'
  s.files       = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 1.9.3'
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'
  s.add_runtime_dependency 'activerecord', '>= 3.0', '< 5.0'
  s.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
end