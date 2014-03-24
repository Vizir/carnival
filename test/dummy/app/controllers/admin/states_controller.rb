module Admin
  class StatesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_state: [:name, :code, :country_id])
    end
  end
end
