class CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  delegate :logger, to: Rails

  def keycloak_events

    process_by_type

    render status: 200, json: @controller.to_json
  end

  private

  def process_by_type
    case params['type']
    when 'admin.USER-CREATE'
      on_user_created
    when 'admin.USER-DELETE'
      on_user_deleted
    when 'admin.REALM_ROLE_MAPPING-CREATE'
      on_role_mapping_created
    when 'admin.REALM_ROLE_MAPPING-DELETE'
      on_role_mapping_deleted
    else
      logger.warn('Unknown event type')
    end
  end

  def on_user_created
    logger.info('on_user_created')
    User.create(
      public_id: user_public_id,
      first_name: resource_representation['username'],
      email: resource_representation['email']
    )
  end

  def on_user_deleted
    logger.info('on_user_deleted')
    user.destroy
  end

  def on_role_mapping_created
    logger.info('on_role_mapping_created')
    role = resource_representation['name'].to_sym
    user.add_role(role)

    return unless user.has_role?(:popug)

    BillingCycle.create(user: user) if BillingCycle.where(user: user).open.empty?
  end

  def on_role_mapping_deleted
    logger.info('on_role_mapping_deleted')
    user.remove_role(resource_representation['name'].to_sym)
  end

  def user
    User.find_by(public_id: user_public_id)
  end

  def user_public_id
    params['resourcePath'].split('/').second
  end

  # Yeah Yikes, nice API
  def resource_representation
    Array.wrap(JSON.parse(params[:representation])).first
  end
end
