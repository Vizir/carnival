module Admin
  class CreditCardsController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_credit_card: [:name])
    end
  end
end
