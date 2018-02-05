Gem::Specification.new do |s|
  s.name          = 'kvvliveapi'
  s.version       = '0.1.0'
  s.date          = '2018-02-05'
  s.summary       = "Unofficial ruby bindings for the KVV (Karlsruher Verkehrsverbund) live API."
  s.description   = "Allows to retrieve live information about train and bus depatures as well as information about stops."
  s.authors       = ["Julian Schuh"]
  s.email         = 'rubygems.dev@jlzmail.de'
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/julianschuh/kvvliveapi'
  s.license       = 'MIT'
end
