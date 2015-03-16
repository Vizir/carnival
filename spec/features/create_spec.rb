require 'rails_helper'

feature 'User creates a new model' do
  scenario 'successfully' do
    visit admin_todos_path

    within('.empty-result') { click_on 'New' }
    fill_in 'todo_title', with: 'Refactor Carnival'

    expect { click_on 'Create' }.to change { Todo.count }.from(0).to(1)
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
