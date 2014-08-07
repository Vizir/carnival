module Admin
  class InstallmentsController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_installment: [:name, :credit_cards_attributes => [:id, :name], credit_card_ids: []])
    end
  end
end
