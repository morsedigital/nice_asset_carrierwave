# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nice_asset_carrierwave/version'

Gem::Specification.new do |spec|
  spec.name          = "nice_asset_carrierwave"
  spec.version       = NiceAssetCarrierwave::VERSION
  spec.authors       = ["Terry S"]
  spec.email         = ["itsterry@gmail.com"]

  spec.summary       = %q{ A nice way of handling assets coming in from Carrierwave }
  spec.homepage      = "https://github.com/morsedigital/nice_asset_carrierwave"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "carrierwave"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-rubocop"
  spec.add_development_dependency "listen"
  spec.add_development_dependency "overcommit"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rubocop"
end
