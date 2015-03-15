require 'rails_helper'

feature 'User sees existing posts' do
  let!(:posts) { create_pair(:post) }

  scenario 'successfully' do
    visit admin_posts_path

    posts.each do |post|
      expect(page).to have_selector('td', text: post.id)
      expect(page).to have_selector('td', text: post.title)
      expect(page).to have_no_selector('td', text: post.content)
    end
  end
end
