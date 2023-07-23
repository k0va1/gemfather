# frozen_string_literal: true

require_relative "cli/settings_reader"
require "fileutils"

module Gemfather
  module Cli
    class Error < StandardError; end

    # Entrypoint of the gem
    class Runner
      attr_accessor :settings

      def initialize(settings_reader = ::Gemfather::Cli::SettingsReader.new)
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
        settings[:coc?] ? "--coc" : "--no-coc"
      end

      def build_ci_options
        cis = { "Github" => "github", "Gitlab" => "gitlab", "Travis" => "travis", "Circle" => "circle" }
        ci_name = cis[settings[:ci]]
        ci_name ? "--ci=#{ci_name}" : ""
      end

      def init_gem
        bundle_options = build_bundle_options
        `bundle gem #{settings[:name]} #{bundle_options} > /dev/null 2>&1 && cd #{settings[:name]}`
      end

      def update_gem_info
        gemspec_path = File.join(Dir.pwd, settings[:name], "#{settings[:name]}.gemspec")
        updated_gemspec_lines = update_gemspec_lines(gemspec_path)

        File.open(gemspec_path, "w") do |f|
          f.write(updated_gemspec_lines.join)
          f.close
        end
      end

      def update_gemspec_lines(gemspec_path) # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/AbcSize
        IO.readlines(gemspec_path).map do |line| # rubocop:disable Metrics/BlockLength
          case line
          when /spec\.summary =.*/
            line.gsub(/=\s".*"/, "= \"#{settings[:summary]}\"")
          when /spec\.description =.*/
            line.gsub(/=\s".*"/, "= \"#{settings[:description]}\"")
          when /spec\.homepage =.*/
            line.gsub(/=\s".*"/, "= \"#{settings[:homepage]}\"")
          when /spec\.metadata\["source_code_uri"\] =.*/
            line.gsub(/=\s".*"/, "= \"#{settings[:homepage]}\"")
          when /spec\.metadata\["changelog_uri"\] =.*/
            line.gsub(/=\s".*"/, "= \"#{settings[:homepage]}/CHANGELOG.md\"") if settings[:changelog?]
          else
            line
          end
        end
      end

      def copy_templates
        copy_makefile
        copy_changelog
      end

      def copy_makefile
        FileUtils.cp(File.join(File.dirname(__dir__), "../templates/Makefile"), new_gem_root) if settings[:makefile?]
      end

      def copy_changelog
        FileUtils.touch("#{new_gem_root}/CHANGELOG.md") if settings[:changelog?]
      end

      def new_gem_root
        @new_gem_root ||= File.join(Dir.pwd, settings[:name])
      end
    end
  end
end
