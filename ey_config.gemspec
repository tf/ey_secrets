# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ey_config/version'

Gem::Specification.new do |spec|
  spec.name          = "ey_config"
  spec.version       = EyConfig::VERSION
  spec.authors       = ["Tim Fischbach"]
  spec.email         = ["tfischbach@codevise.de"]
  spec.summary       = "Manage config files accross Engine Yard instances."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'engineyard-cloud-client', '~> 1.0'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rainbow', '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.4"
  spec.add_development_dependency "rake"
end
