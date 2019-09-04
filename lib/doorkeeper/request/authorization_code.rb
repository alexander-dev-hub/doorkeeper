# frozen_string_literal: true

module Doorkeeper
  module Request
    class AuthorizationCode < Strategy
      delegate :client, :parameters, to: :server

      def request
        @request ||= OAuth::AuthorizationCodeRequest.new(
          Doorkeeper.configuration,
          grant,
          client,
          parameters
        )
      end

      private

      def grant
        raise Errors::MissingRequiredParameter, :code if parameters[:code].blank?

        AccessGrant.by_token(parameters[:code])
      end
    end
  end
end
