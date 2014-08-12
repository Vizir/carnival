class Carnival::AvatarsController < Carnival::BaseAdminController

  def permitted_params
    params.permit(avatar: [:photo])
  end
end
