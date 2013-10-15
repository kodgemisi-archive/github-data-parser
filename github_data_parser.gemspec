# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_data_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "github_data_parser"
  spec.version       = GithubDataParser::VERSION
  spec.authors       = ["Mehmet Beydogan"]
  spec.email         = ["m@mehmet.pw"]
  spec.description   = "A Gem that parses users' github data"
  spec.summary       = "A Gem that parses users' github data"
  spec.homepage      = "https://github.com/kodgemisi/github_data_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
