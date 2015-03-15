require 'rails_helper'

feature 'User sees a specific posts' do
  let!(:post) { create(:post) }

  scenario 'successfully' do
    visit admin_posts_path

    click_on 'View'

    expect(current_path).to eq(admin_post_path(post.id))
    expect(page).to have_text(post.id)
    expect(page).to have_text(post.title)
    expect(page).to have_text(post.content)
  end
end
