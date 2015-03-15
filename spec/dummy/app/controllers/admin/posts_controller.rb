class Admin::PostsController < Carnival::BaseAdminController
  layout 'carnival/admin'

  def permitted_params
    params.permit(post: [:title, :content])
  end
end
