# frozen_string_literal: true

require "spec_helper"

describe Doorkeeper::VERSION do
  context "#gem_version" do
    it "returns Gem::Version instance" do
      expect(Doorkeeper.gem_version).to be_an_instance_of(Gem::Version)
    end
  end

  context "VERSION" do
    it "returns gem version string" do
      expect(Doorkeeper::VERSION::STRING).to match(/^\d+\.\d+\.\d+(\.\w+)?$/)
    end
  end
end
