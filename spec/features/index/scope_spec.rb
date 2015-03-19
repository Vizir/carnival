require 'rails_helper'

feature 'User sees scoped data' do
  let!(:todo_todos) { create_pair(:todo, :todo) }
  let!(:doing_todos) { create_list(:todo, 3, :doing) }
  let!(:done_todos) { create_pair(:todo, :done) }

  scenario 'successfully', js: true do
    visit admin_todos_path

    find('a', text: 'Todo (2)').click

    page_should_have_todos todo_todos
    page_should_not_have_todos doing_todos
    page_should_not_have_todos done_todos

    find('a', text: 'Doing (3)').click

    page_should_have_todos doing_todos
    page_should_not_have_todos todo_todos
    page_should_not_have_todos done_todos

    find('a', text: 'Done (2)').click

    page_should_have_todos done_todos
    page_should_not_have_todos todo_todos
    page_should_not_have_todos doing_todos
  end
end
