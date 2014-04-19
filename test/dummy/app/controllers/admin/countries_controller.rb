module Admin
  class CountriesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_country: [:name, :code, :states_attributes => [:id, :name, :code, :_destroy], :cities_attributes => [:id, :name, :state_id, :_destroy]])
    end
  end
end
