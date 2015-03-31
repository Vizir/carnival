require 'rails_helper'

feature 'User sees existing todos' do
  let!(:todos) { create_pair(:todo) }

  scenario 'successfully' do
    visit admin_todos_path

    todos.each do |todo|
      expect(page).to have_selector('td', text: todo.id)
      expect(page).to have_selector('td', text: todo.title)
    end
  end
end
