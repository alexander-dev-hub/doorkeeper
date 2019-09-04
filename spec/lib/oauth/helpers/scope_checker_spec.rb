# frozen_string_literal: true

require "spec_helper"

module Doorkeeper::OAuth::Helpers
  describe ScopeChecker, ".valid?" do
    let(:server_scopes) { Doorkeeper::OAuth::Scopes.new }

    it "is valid if scope is present" do
      server_scopes.add :scope
      expect(ScopeChecker.valid?(scope_str: "scope", server_scopes: server_scopes)).to be_truthy
    end

    it "is invalid if includes tabs space" do
      expect(ScopeChecker.valid?(scope_str: "\tsomething", server_scopes: server_scopes)).to be_falsey
    end

    it "is invalid if scope is not present" do
      expect(ScopeChecker.valid?(scope_str: nil, server_scopes: server_scopes)).to be_falsey
    end

    it "is invalid if scope is blank" do
      expect(ScopeChecker.valid?(scope_str: " ", server_scopes: server_scopes)).to be_falsey
    end

    it "is invalid if includes return space" do
      expect(ScopeChecker.valid?(scope_str: "scope\r", server_scopes: server_scopes)).to be_falsey
    end

    it "is invalid if includes new lines" do
      expect(ScopeChecker.valid?(scope_str: "scope\nanother", server_scopes: server_scopes)).to be_falsey
    end

    it "is invalid if any scope is not included in server scopes" do
      expect(ScopeChecker.valid?(scope_str: "scope another", server_scopes: server_scopes)).to be_falsey
    end

    context "with application_scopes" do
      let(:server_scopes) do
        Doorkeeper::OAuth::Scopes.from_string "common svr"
      end
      let(:application_scopes) do
        Doorkeeper::OAuth::Scopes.from_string "app123"
      end

      it "is valid if scope is included in the application scope list" do
        expect(ScopeChecker.valid?(scope_str: "app123",
                                   server_scopes: server_scopes,
                                   app_scopes: application_scopes)).to be_truthy
      end

      it "is invalid if any scope is not included in the application" do
        expect(ScopeChecker.valid?(scope_str: "svr",
                                   server_scopes: server_scopes,
                                   app_scopes: application_scopes)).to be_falsey
      end
    end

    context "with grant_type" do
      let(:server_scopes) do
        Doorkeeper::OAuth::Scopes.from_string "scope1 scope2"
      end

      context "with scopes_by_grant_type not configured for grant_type" do
        it "is valid if the scope is in server scopes" do
          expect(ScopeChecker.valid?(scope_str: "scope1",
                                     server_scopes: server_scopes,
                                     grant_type: Doorkeeper::OAuth::PASSWORD)).to be_truthy
        end

        it "is invalid if the scope is not in server scopes" do
          expect(ScopeChecker.valid?(scope_str: "unknown",
                                     server_scopes: server_scopes,
                                     grant_type: Doorkeeper::OAuth::PASSWORD)).to be_falsey
        end
      end

      context "when scopes_by_grant_type configured for grant_type" do
        before do
          allow(Doorkeeper.configuration).to receive(:scopes_by_grant_type)
            .and_return(password: [:scope1])
        end

        it "is valid if the scope is permitted for grant_type" do
          expect(ScopeChecker.valid?(scope_str: "scope1",
                                     server_scopes: server_scopes,
                                     grant_type: Doorkeeper::OAuth::PASSWORD)).to be_truthy
        end

        it "is invalid if the scope is permitted for grant_type" do
          expect(ScopeChecker.valid?(scope_str: "scope2",
                                     server_scopes: server_scopes,
                                     grant_type: Doorkeeper::OAuth::PASSWORD)).to be_falsey
        end
      end
    end
  end
end
