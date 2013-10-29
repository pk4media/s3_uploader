# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3uploader/version'

Gem::Specification.new do |spec|
  spec.name          = "s3uploader"
  spec.version       = S3uploader::VERSION
  spec.authors       = ["Stan Dyro", "Kaushik Sanyal"]
  spec.email         = ["stand@pk4media.com"]
  spec.description   = "S3 signing methods for controller"
  spec.summary       = "S3 signing methods for controller"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
