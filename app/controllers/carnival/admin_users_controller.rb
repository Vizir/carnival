module Carnival

  class AdminUsersController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_admin_user: [:name, :email, :password, :password_confirmation])
    end
  end
end
