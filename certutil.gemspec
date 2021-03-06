# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'certutil/version'

Gem::Specification.new do |spec|
  spec.name          = "certutil"
  spec.version       = Certutil::VERSION
  spec.authors       = ["Chad Bailey"]
  spec.email         = ["chad@heroku.com"]
  spec.summary       = %q{A tool for decoding and analyzing SSL certificates.}
  spec.description   = %q{A tool for decoding and analyzing SSL certificates.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake', '~> 0.9.2')
  spec.add_dependency('methadone', '~> 1.3.2')
end
