module Admin
  class TestesController < Carnival::BaseAdminController
    layout "admin/admin"

    def permitted_params
      params.permit(admin_teste: [:campo1, :campo2])
    end
  end
end
