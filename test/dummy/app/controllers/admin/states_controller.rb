module Admin
  class StatesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_state: [:name, :code, :country_id, :city_ids => [], :cities_attributes => [:id, :name, :state_id, :country_id,:_destroy]])
    end
  end
end
