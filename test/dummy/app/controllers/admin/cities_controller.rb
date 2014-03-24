module Admin
  class CitiesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_city: [:name, :country_id, :state_id])
    end
  end
end
