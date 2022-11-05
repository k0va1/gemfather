# frozen_string_literal: true

require_relative "lib/gemfather/version"

Gem::Specification.new do |spec|
  spec.name = "gemfather"
  spec.version = Gemfather::VERSION
  spec.authors = ["k0va1"]
  spec.email = ["al3xander.koval@gmail.com"]

  spec.summary = "Gem for creating other gems"
  spec.description = "Ask some questions & create a new gem template"
  spec.homepage = "https://gitlab.com/k0va1/gemfather"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/k0va1/gemfather"
  spec.metadata["changelog_uri"] = "https://gitlab.com/k0va1/gemfather"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.executables = "gemfather"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "tty-prompt", "~> 0.23"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
