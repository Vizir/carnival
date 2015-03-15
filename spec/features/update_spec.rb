require 'rails_helper'

feature 'User updates an exisint model' do
  before { create(:post) }

  scenario 'successfully' do
    visit admin_posts_path

    new_title = 'Carnival Title Update'
    click_on 'Edit'
    fill_in 'post_title', with: new_title

    expect { click_on 'Update' }.to change { Post.count }.by(0)
    expect(page).to have_content new_title
  end

  scenario 'incompletely' do
    visit admin_posts_path

    click_on 'Edit'
    fill_in 'post_title', with: ''

    expect { click_on 'Update' }.to change { Post.count }.by(0)
    expect(page).to have_text('Title can\'t be blank')
  end
end
