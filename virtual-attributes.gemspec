$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'virtual-attributes'
  s.version     = '0.1.2'
  s.date        = '2015-03-19'
  s.summary     = "Enhance ActiveRecord's Serialize with typed virtual attributes"
  s.description = "Allow you to add virtual type attributes in one single serialized ActiveRecord attribute"
  s.authors     = ["ihcene"]
  s.email       = 'ihcene@aritylabs.com'
  s.files       = `git ls-files`.split($/)
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 1.9.3'
  s.homepage    = 'https://github.com/ihcene/virtual-attributes'
  s.license     = 'MIT'
  s.add_runtime_dependency 'activerecord', '>= 3.0', '< 5.0'
  s.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
end