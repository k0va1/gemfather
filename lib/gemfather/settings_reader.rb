# frozen_string_literal: true

require "tty-prompt"

module Gemfather
  # Class responsible to collect user input and build settings hash
  class SettingsReader
    def call # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      settings = {}
      prompt = TTY::Prompt.new

      settings[:name] = prompt.ask("Gem name:", default: "awesome-new-gem")
      settings[:summary] = prompt.ask("Summary", default: "awesome-new-gem")
      settings[:description] = prompt.ask("Description", default: "awesome-new-gem")
      settings[:homepage] = prompt.ask("Home page(URL)", default: "awesome-new-gem")

      settings[:linter] = prompt.select("Select linter") do |menu|
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

      settings[:ci] = prompt.select("Select CI tool:") do |menu|
        menu.choice "GitHub"
        menu.choice "Gitlab"
        menu.choice "Travis"
        menu.choice "Circle"
      end

      settings[:makefile?] = prompt.yes?("Do you need Makefile?")
      settings[:coc] = prompt.yes?("Do you need Code Of Conduct?")

      settings[:debugger] = prompt.select("Select debugger tool:") do |menu|
        menu.choice "IRB"
        menu.choice "Pry"
      end

      settings
    end
  end
end
