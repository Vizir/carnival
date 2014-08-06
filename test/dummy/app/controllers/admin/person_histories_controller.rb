module Admin
  class PersonHistoriesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_person_history: [:history])
    end
  end
end
