class CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  delegate :logger, to: Rails

  def keycloak_events
    logger.info('Callback from Keycloak received with params:')

    logger.info(params.inspect)
  end

  private

  def on_user_created()

  end

  def on_role_changed()

  end

  def on_user_logged_out()

  end
end
