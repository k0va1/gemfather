# frozen_string_literal: true

require "fileutils"

RSpec.describe Gemfather::Runner do
  describe "run" do
    subject { described_class.new(settings_reader).call }

    let(:settings_reader) { instance_double("Gemfather::SettingsReader") }
    let(:settings_mock) do 
      {
        name: "new_gem",
        summary: "new_summary",
        description: "new_description",
        homepage: "new_homepage",
        linter: "Rubocop",
        test: "RSpec",
        ci: "GitHub",
        makefile?: true,
        coc: true,
        debugger: "IRB"
      }
    end
    before do
      allow(settings_reader).to receive(:call).and_return(settings_mock)
    end

    it "runs successfuly" do
      subject

      expect(File).to exist("new_gem")
    end

    after do
      FileUtils.remove_dir("new_gem")
    end
  end
end
