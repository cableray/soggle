# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soggle/version'

Gem::Specification.new do |gem|
  gem.name          = "soggle"
  gem.version       = Soggle::VERSION
  gem.authors       = ["cableray"]
  gem.email         = ["cableraywire@gmail.com"]
  gem.description   = %q{Soggle looks for words on a boggle-style grid}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'ffi-aspell'
  gem.add_dependency 'commander'

  gem.add_development_dependency 'rspec'
end
