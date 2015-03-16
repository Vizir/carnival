require 'rails_helper'

feature 'User sees a specific todos' do
  let!(:todo) { create(:todo) }

  scenario 'successfully' do
    visit admin_todos_path

    click_on 'View'

    expect(current_path).to eq(admin_todo_path(todo.id))
    expect(page).to have_text(todo.id)
    expect(page).to have_text(todo.title)
  end
end
