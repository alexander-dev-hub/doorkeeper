# frozen_string_literal: true

module Doorkeeper
  module OAuth
    class ClientCredentialsRequest < BaseRequest
      class Creator
        def call(client, scopes, attributes = {})
          existing_token = existing_token_for(client, scopes)

          if Doorkeeper.configuration.reuse_access_token && existing_token&.reusable?
            return existing_token
          end

          existing_token&.revoke

          AccessToken.find_or_create_for(
            client, nil, scopes, attributes[:expires_in],
            attributes[:use_refresh_token]
          )
        end

        private

        def existing_token_for(client, scopes)
          Doorkeeper::AccessToken.matching_token_for client, nil, scopes
        end
      end
    end
  end
end
