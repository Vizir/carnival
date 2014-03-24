module Admin
  class PeopleController < Carnival::BaseAdminController
    layout "admin/admin"

    def permitted_params
      params.permit(admin_person: [:name, :email, :dob, :country_id, :state_id, :city_id, :address, :address_complement, :number, :zipcode, :employed])
    end
  end
end
