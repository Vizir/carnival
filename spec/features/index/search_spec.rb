require 'rails_helper'

feature 'User filters existing todos', js: true do
  let!(:search_todo) { create(:todo) }
  let!(:missing_todo) { create(:todo) }

  scenario 'successfully' do
    visit admin_todos_path

    click_on 'Advanced Search'
    fill_in 'advanced_search[title]', with: search_todo.title
    click_on 'Search'

    expect(page).to have_text(search_todo.title)
    expect(page).to have_no_text(missing_todo.title)
  end
end
