# frozen_string_literal: true

require_relative "gemfather/version"
require "tty-prompt"

module Gemfather
  class Error < StandardError; end
  class Runner
    attr_accessor :settings

    def initialize
      @settings = {}
    end

    def default_settings
    end

    def run
      prompt = TTY::Prompt.new

      settings[:name] = prompt.ask("Gem name:", default: "awesome-new-gem")
      settings[:makefile?] = prompt.yes?("Do you need Makefile?")
      settings[:linter] = prompt.select("Select test tool:") do |menu|
        menu.choice "Rubocop"
        menu.choice "Standard"
        menu.choice "N/A"
      end
      settings[:test] = prompt.select("Select test tool:") do |menu|
        menu.choice "RSpec"
        menu.choice "Minitest"
        menu.choice "TestUnit"
        menu.choice "N/A"
      end

      settings[:summary] = prompt.ask("Summary", default: "awesome-new-gem")
      settings[:description] = prompt.ask("Description", default: "awesome-new-gem")
      settings[:home_page] = prompt.ask("Home page(URL)", default: "awesome-new-gem")
      settings[:debugger] = prompt.select("Select debugger tool:") do |menu|
        menu.choice "IRB"
        menu.choice "Pry"
      end

      puts settings
      `bundle gem #{settings[:name]}`
    end
  end
end

