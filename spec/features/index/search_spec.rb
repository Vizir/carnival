require 'rails_helper'

feature 'User filters existing posts', js: true do
  let!(:search_post) { create(:post) }
  let!(:missing_post) { create(:post) }

  scenario 'successfully' do
    visit admin_posts_path

    click_on 'Advanced Search'
    fill_in 'advanced_search[title]', with: search_post.title
    click_on 'Search'

    expect(page).to have_text(search_post.title)
    expect(page).to have_no_text(missing_post.title)
  end
end
