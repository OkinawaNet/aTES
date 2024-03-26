require 'omniauth'
require 'omniauth-oauth2'
require 'json/jwt'
require 'uri'

module OmniAuth
  module Strategies
    class KeycloakOpenId < OmniAuth::Strategies::OAuth2
      def request_phase
        options.authorize_options.each { |key| options[key] = request.params[key.to_s] }

        if Rails.env.development?
          local_client = ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options.merge({site: Settings.keycloak.local_url})))
          redirect local_client.auth_code.authorize_url({ redirect_uri: callback_url }.merge(authorize_params))
        else
          super
        end
      end
    end
  end
end
