class AddTodoListRelationToTodos < ActiveRecord::Migration
  def change
    add_reference :todos, :todo_list, index: true
  end
end
