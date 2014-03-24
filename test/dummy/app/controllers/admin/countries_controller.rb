module Admin
  class CountriesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_country: [:name, :code])
    end
  end
end
