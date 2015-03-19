require 'rails_helper'

feature 'User creates a new model' do
  scenario 'successfully' do
    visit admin_todos_path
    todo_title = 'Refactor Carnival'
    todo_status = 'todo'

    within('.empty-result') { click_on 'New' }
    fill_in 'todo_title', with: todo_title
    select todo_status, from: 'todo_status'

    expect { click_on 'Create' }.to change { Todo.count }.from(0).to(1)
    expect(page).to have_text(todo_title)
    expect(page).to have_text(todo_status)
  end

  scenario 'incompletely' do
    visit admin_todos_path

    within('.empty-result') { click_on 'New' }
    fill_in 'todo_title', with: ''

    expect { click_on 'Create' }.to_not change { Todo.count }
    expect(current_path).to eq(admin_todos_path)
    expect(page).to have_text('Title can\'t be blank')
  end
end
