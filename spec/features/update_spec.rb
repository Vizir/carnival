require 'rails_helper'

feature 'User updates an exisint model' do
  before { create(:todo) }

  scenario 'successfully' do
    visit admin_todos_path

    new_title = 'Update Task Title'
    click_on 'Edit'
    fill_in 'todo_title', with: new_title

    expect { click_on 'Update' }.to_not change { Todo.count }
    expect(page).to have_content new_title
  end

  scenario 'incompletely' do
    visit admin_todos_path

    click_on 'Edit'
    fill_in 'todo_title', with: ''

    expect { click_on 'Update' }.to_not change { Todo.count }
    expect(page).to have_text('Title can\'t be blank')
  end
end
