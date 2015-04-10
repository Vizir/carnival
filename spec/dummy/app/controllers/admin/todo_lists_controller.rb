class Admin::TodoListsController < Carnival::BaseAdminController
  layout 'carnival/admin'

  def permitted_params
    params.permit(todo_list: [:name])
  end
end
