module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def keycloakopenid
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        flash[:error] = 'Error when trying to login with Keycloak, please try again.'
        session["devise.keycloakopenid_data"] = request.env["omniauth.auth"]
        redirect_to root_path
      end
    end
  end
end