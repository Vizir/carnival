module Carnival

  class AdminUsersController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(carnival_admin_user: [:name, :email, :password, :password_confirmation, :photo])
    end
  end
end
