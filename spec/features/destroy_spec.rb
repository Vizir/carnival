require 'rails_helper'

feature 'User creates a new model' do
  before { create(:todo) }

  scenario 'successfully' do
    visit admin_todos_path

    expect { click_on 'Delete' }.to change { Todo.count }.from(1).to(0)
  end
end
