Gem::Specification.new do |spec|
  spec.name          = "s3_uploader"
  spec.version       = "0.0.7"
  spec.authors       = ["Stan Dyro", "Kaushik Sanyal"]
  spec.email         = ["stand@pk4media.com"]
  spec.description   = "S3 signing methods for controller"
  spec.summary       = "S3 signing methods for controller"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
