class CallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  delegate :logger, to: Rails

  def keycloak_events
    logger.info('Callback from Keycloak received')
    process_by_type
  end

  private
  # task-tracker    |   Parameters: {"time"=>1710452036795, "realmId"=>"master", "operationType"=>"CREATE", "resourcePath"=>"users/a2bd7fcd-4dcf-4fff-af1c-76a2e8fd3a1e/role-mappings/realm", "representation"=>"[{\"id\":\"a1d9e1f5-876c-4fd1-b1ee-b7d2bd806c90\",\"name\":\"popug\",\"description\":\"\",\"composite\":false,\"clientRole\":false,\"containerId\":\"0dfe740c-fc15-4889-9b43-978fd61d0da0\"}]", "uid"=>"ec5a81bb-9d18-4a59-8dbf-ed94a97450e3", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.REALM_ROLE_MAPPING-CREATE", "details"=>{}, "resourceType"=>"REALM_ROLE_MAPPING", "callback"=>{"time"=>1710452036795, "realmId"=>"master", "operationType"=>"CREATE", "resourcePath"=>"users/a2bd7fcd-4dcf-4fff-af1c-76a2e8fd3a1e/role-mappings/realm", "representation"=>"[{\"id\":\"a1d9e1f5-876c-4fd1-b1ee-b7d2bd806c90\",\"name\":\"popug\",\"description\":\"\",\"composite\":false,\"clientRole\":false,\"containerId\":\"0dfe740c-fc15-4889-9b43-978fd61d0da0\"}]", "uid"=>"ec5a81bb-9d18-4a59-8dbf-ed94a97450e3", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.REALM_ROLE_MAPPING-CREATE", "details"=>{}, "resourceType"=>"REALM_ROLE_MAPPING"}}
  # task-tracker    |   Parameters: {"time"=>1710452343335, "realmId"=>"master", "operationType"=>"DELETE", "resourcePath"=>"users/bbe85f9d-0d86-429a-a280-54030f87a37e/role-mappings/realm", "representation"=>"[{\"id\":\"ee3468d2-0bf4-4021-81f6-01589232932f\",\"name\":\"create-realm\",\"composite\":false}]", "uid"=>"c33873db-4aa6-4108-a246-0c25f250db73", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.REALM_ROLE_MAPPING-DELETE", "details"=>{}, "resourceType"=>"REALM_ROLE_MAPPING", "callback"=>{"time"=>1710452343335, "realmId"=>"master", "operationType"=>"DELETE", "resourcePath"=>"users/bbe85f9d-0d86-429a-a280-54030f87a37e/role-mappings/realm", "representation"=>"[{\"id\":\"ee3468d2-0bf4-4021-81f6-01589232932f\",\"name\":\"create-realm\",\"composite\":false}]", "uid"=>"c33873db-4aa6-4108-a246-0c25f250db73", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.REALM_ROLE_MAPPING-DELETE", "details"=>{}, "resourceType"=>"REALM_ROLE_MAPPING"}}
  # task-tracker    |   Parameters: {"time"=>1710452394921, "realmId"=>"master", "operationType"=>"CREATE", "resourcePath"=>"users/753808c2-f38e-4527-bf44-933e3e7063e4", "representation"=>"{\"username\":\"test\",\"enabled\":true,\"emailVerified\":false,\"firstName\":\"\",\"lastName\":\"\",\"email\":\"\",\"attributes\":{},\"requiredActions\":[],\"groups\":[]}", "uid"=>"5f377ed9-16d6-4a32-b239-35b276655a9d", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.USER-CREATE", "details"=>{"userId"=>"753808c2-f38e-4527-bf44-933e3e7063e4", "username"=>"test"}, "resourceType"=>"USER", "callback"=>{"time"=>1710452394921, "realmId"=>"master", "operationType"=>"CREATE", "resourcePath"=>"users/753808c2-f38e-4527-bf44-933e3e7063e4", "representation"=>"{\"username\":\"test\",\"enabled\":true,\"emailVerified\":false,\"firstName\":\"\",\"lastName\":\"\",\"email\":\"\",\"attributes\":{},\"requiredActions\":[],\"groups\":[]}", "uid"=>"5f377ed9-16d6-4a32-b239-35b276655a9d", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.USER-CREATE", "details"=>{"userId"=>"753808c2-f38e-4527-bf44-933e3e7063e4", "username"=>"test"}, "resourceType"=>"USER"}}
  # task-tracker    | #<ActionController::Parameters {"time"=>1710452662153, "realmId"=>"master", "operationType"=>"DELETE", "resourcePath"=>"users/eff5c5da-ad55-4f59-a5e3-8170440c68e9", "uid"=>"5c064845-08cb-46a2-8447-01b046fbb6c2", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.USER-DELETE", "details"=>{"userId"=>"eff5c5da-ad55-4f59-a5e3-8170440c68e9"}, "resourceType"=>"USER", "controller"=>"callbacks", "action"=>"keycloak_events", "callback"=>{"time"=>1710452662153, "realmId"=>"master", "operationType"=>"DELETE", "resourcePath"=>"users/eff5c5da-ad55-4f59-a5e3-8170440c68e9", "uid"=>"5c064845-08cb-46a2-8447-01b046fbb6c2", "authDetails"=>{"realmId"=>"master", "clientId"=>"bcdc8e69-77ac-433c-9d9e-8418865ad724", "userId"=>"e13ce5e1-9b11-426d-a4f3-375e6eeb2716", "ipAddress"=>"172.28.0.1", "username"=>"admin"}, "type"=>"admin.USER-DELETE", "details"=>{"userId"=>"eff5c5da-ad55-4f59-a5e3-8170440c68e9"}, "resourceType"=>"USER"}} permitted: false>



  def process_by_type
    case params['type']
    when 'admin.USER-CREATE'
      on_user_created
    when 'admin.USER-DELETE'
      on_user_deleted
    when 'admin.REALM_ROLE_MAPPING-CREATE'
      on_role_created
    when 'admin.REALM_ROLE_MAPPING-DELETE'
      on_role_deleted
    else
      logger.warn('Unknown event type')
    end
  end

  def on_user_created

  end

  def on_user_deleted

  end

  def on_role_created

  end

  def on_role_deleted

  end
end
