require 'rails_helper'

feature 'User paginates existing posts', js: true do
  let!(:post_count) { 51 }
  let!(:posts) { create_list(:post, post_count) }
  let!(:last_post) { posts.last }

  scenario 'successfully' do
    visit admin_posts_path

    expect(page).to have_text("Total: #{post_count}")

    find('a', text: 'Next »').click

    expect(page).to have_selector('td', text: last_post.id)
    expect(page).to have_selector('td', text: last_post.title)
    expect(page).to have_selector('span.carnival-selected-page-button', text: '2')
  end
end
