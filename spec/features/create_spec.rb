require 'rails_helper'

feature 'User creates a new model' do
  scenario 'successfully' do
    visit admin_posts_path

    within('.empty-result') { click_on 'New' }
    fill_in 'post_title', with: 'Carnival'
    fill_in 'post_content', with: 'A new admin engine'
    # status

    expect { click_on 'Create' }.to change { Post.count }.by(1)
  end

  scenario 'incompletely' do
    visit admin_posts_path

    within('.empty-result') { click_on 'New' }
    fill_in 'post_title', with: 'Carnival'

    expect { click_on 'Create' }.to_not change { Post.count }
    expect(current_path).to eq(admin_posts_path)
    expect(page).to have_no_text('Title can\'t be blank')
    expect(page).to have_text('Content can\'t be blank')
  end
end
