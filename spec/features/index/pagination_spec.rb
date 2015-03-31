require 'rails_helper'

feature 'User paginates existing todos', js: true do
  let!(:todo_count) { 51 }
  let!(:todos) { create_list(:todo, todo_count) }
  let!(:last_todo) { todos.last }

  scenario 'successfully' do
    visit admin_todos_path

    expect(page).to have_text("Total: #{todo_count}")

    find('a', text: 'Next »').click

    expect(page).to have_selector('td', text: last_todo.id)
    expect(page).to have_selector('td', text: last_todo.title)
    expect(page).to have_selector('span.carnival-selected-page-button', text: '2')
  end
end
