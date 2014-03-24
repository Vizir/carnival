module Carnival
  class SessionsController < Devise::SessionsController
    layout "carnival/admin"
    def create
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
      set_flash_message(:success, :signed_in) if is_navigational_format?
      redirect_to admin_root_url
    end

    def destroy
      redirect_path = after_sign_out_path_for(resource_name)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message :success, :signed_out if signed_out && is_navigational_format?
      # We actually need to hardcode this as Rails default responder doesn't
      # support returning empty response on GET request
      respond_to do |format|
        format.any(*navigational_formats) { redirect_to redirect_path }
        format.all do
          head :no_content
        end
      end
    end
  end
end
