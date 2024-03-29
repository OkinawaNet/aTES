require_relative "boot"

require "rails/all"
require 'httplog'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.hosts << /.*/

    if defined?(Rails::Server)
      config.after_initialize do
        # Subscribe for keycloak events
        Rails.logger.info('Subscribe for keycloak events')
        kc_client = ApiClient::KeycloakClient.new
        kc_client.get_webhooks.each { |webhook| kc_client.delete_webhook(webhook['id']) }
        kc_client.create_webhook
      end
    end
  end
end
