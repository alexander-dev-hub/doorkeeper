# frozen_string_literal: true

require "spec_helper"

module Doorkeeper::OAuth
  describe Error do
    subject(:error) { Error.new(:some_error, :some_state) }

    it { expect(subject).to respond_to(:name) }
    it { expect(subject).to respond_to(:state) }

    describe :description do
      it "is translated from translation messages" do
        expect(I18n).to receive(:translate).with(
          :some_error,
          scope: %i[doorkeeper errors messages],
          default: :server_error
        )
        error.description
      end
    end
  end
end
