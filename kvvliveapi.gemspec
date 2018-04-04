lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kvvliveapi/version'

Gem::Specification.new do |s|
  s.name          = 'kvvliveapi'
  s.version       = KVVLiveAPI::VERSION
  s.date          = '2018-02-05'
  s.summary       = "Inofficial ruby bindings for the KVV (Karlsruher Verkehrsverbund) live API."
  s.description   = "Allows to retrieve live information about train and bus depatures as well as information about stops."
  s.authors       = ["Julian Schuh"]
  s.email         = 'rubygems.dev@jlzmail.de'
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/julianschuh/kvvliveapi'
  s.license       = 'MIT'

  s.add_runtime_dependency 'faraday', '~> 0.14.0'
  s.add_runtime_dependency 'activesupport', '~> 5.1'
end
