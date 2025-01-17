# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asset_bom_removal/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "asset_bom_removal-rails"
  spec.version       = AssetBomRemoval::Rails::VERSION
  spec.authors       = ["Government Digital Service"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]

  spec.summary       = "Removes the BOM from CSS files in rails asset pipeline"
  spec.description   = "Hooks into rails asset:precompile task to remove the BOM from any CSS files generated by SASS.  Firefox < 52 has a bug when calculating SRI for CSS files with a BOM and removing it has no downsides so that's what we do."
  spec.homepage      = "https://github.com/alphagov/asset_bom_removal-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.2"
  spec.add_dependency "sass", "> 3.4"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "govuk-lint"
end
