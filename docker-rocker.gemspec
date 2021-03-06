# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_rocker/version'

Gem::Specification.new do |spec|
  spec.name          = "docker-rocker"
  spec.version       = DockerRocker::VERSION
  spec.authors       = ["Christopher J. Bottaro"]
  spec.email         = ["cjbottaro@alumni.cs.utexas.edu"]

  spec.summary       = %q{Tools to make working with docker less painful, including a Dockerfile preprocessor}
  spec.description   = %q{So far it's just a Dockerfile preprocessor}
  spec.homepage      = "https://github.com/cjbottaro/docker-rocker"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["rocker"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "pry", "~> 0.10.0"

  spec.add_dependency "thor", "~> 0.19.0"
  spec.add_dependency "aws-sdk", "~> 2"
end
