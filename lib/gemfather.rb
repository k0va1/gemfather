# frozen_string_literal: true

require_relative "gemfather/version"
require_relative "gemfather/settings_reader"
require "fileutils"

module Gemfather
  class Error < StandardError; end

  class Runner
    attr_accessor :settings

    def initialize(settings_reader = ::Gemfather::SettingsReader.new)
      @settings_reader = settings_reader
    end

    def call
      populate_settings
      init_gem
      update_gem_info
      copy_templates
    end

    private

    def populate_settings
      @settings = @settings_reader.call
    end

    def build_bundle_options
      linter_options = build_linter_options
      test_options = build_test_options
      coc_options = build_coc_options
      ci_options = build_ci_options

      [
        linter_options,
        test_options,
        coc_options,
        ci_options
      ].join(" ")
    end

    def build_linter_options
      case settings[:linter]
      when "Rubocop"
        "--linter=rubocop"
      when "Standard"
        "--linter=standard"
      else
        ""
      end
    end

    def build_test_options
      case settings[:test]
      when "Minitest"
        "--test=minitest"
      when "RSpec"
        "--test=rspec"
      when "TestUnit"
        "--test=test-unit"
      else
        ""
      end
    end

    def build_coc_options
      settings[:coc] ? "--coc" : "--no-coc"
    end

    def build_ci_options
      case settings[:ci]
      when "GitHub"
        "--ci=github"
      when "Gitlab"
        "--ci=gitlab"
      when "Travis"
        "--ci=travis"
      when "Circle"
        "--ci=circle"
      else
        ""
      end
    end

    def init_gem
      bundle_options = build_bundle_options
      `bundle gem #{settings[:name]} #{bundle_options}`
    end

    def update_gem_info
      gemspec_path = File.join(Dir.pwd, settings[:name], "#{settings[:name]}.gemspec")

      gemspec_info_lines = IO.readlines(gemspec_path).map do |line|
        case line
        when /spec\.summary =.*/
          line.gsub(/=\s\".*\"/, "= \"#{settings[:summary]}\"")
        when /spec\.description =.*/
          line.gsub(/=\s\".*\"/, "= \"#{settings[:description]}\"")
        when /spec\.homepage =.*/
          line.gsub(/=\s\".*\"/, "= \"#{settings[:homepage]}\"")
        else
          line
        end
      end

      File.open(gemspec_path, "w") do |f|
        f.write(gemspec_info_lines.join)
        f.close
      end
    end

    def copy_templates
      if settings[:makefile?]
        new_gem_root = File.join(Dir.pwd, settings[:name])
        FileUtils.cp(File.join(File.dirname(__dir__), "templates/Makefile"), new_gem_root)
      end
    end
  end
end
