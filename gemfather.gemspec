# frozen_string_literal: true

require_relative "lib/gemfather/cli/version"

Gem::Specification.new do |spec|
  spec.name = "gemfather-cli"
  spec.version = Gemfather::Cli::VERSION
  spec.authors = ["k0va1"]
  spec.email = ["al3xander.koval@gmail.com"]

  spec.summary = "Gem for creating other gems"
  spec.description = "Ask some questions & create a new gem template"
  spec.homepage = "https://gitlab.com/k0va1/gemfather-cli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/k0va1/gemfather-cli"
  spec.metadata["changelog_uri"] = "https://gitlab.com/k0va1/gemfather-cli"

  spec.files = Dir.glob("{lib,templates}/**/*", File::FNM_DOTMATCH)
  spec.bindir = "exe"
  spec.executables = ["gemfather"]

  spec.add_runtime_dependency("tty-prompt", "~> 0.23")
end
