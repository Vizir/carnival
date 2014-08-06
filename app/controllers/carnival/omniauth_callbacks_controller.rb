module Carnival
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      class_name = Carnival::Config.devise_class_name
      @user = class_name.constantize.find_for_omni_auth(request.env["omniauth.auth"])

      if @user.nil?
        flash.notice = I18n.t("user_not_found")
        redirect_to new_admin_user_session_path
      elsif @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end

    def google_oauth2
      class_name = Carnival::Config.devise_class_name
      @user = class_name.constantize.find_for_omni_auth(request.env["omniauth.auth"])
      if @user.nil?
        flash.notice = I18n.t("user_not_found")
        redirect_to new_admin_user_session_path
      elsif @user.persisted?
        flash.notice = "Signed in Through Google!"
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      else
        session["devise.user_attributes"] = @user.attributes
        flash.notice = "You are almost Done! Please provide a password to finish setting up your account"
        redirect_to new_user_registration_url
      end
    end
  end
end
