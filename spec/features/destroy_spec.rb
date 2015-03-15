require 'rails_helper'

feature 'User creates a new model' do
  before { create(:post) }

  scenario 'successfully' do
    visit admin_posts_path

    expect { click_on 'Delete' }.to change { Post.count }.from(1).to(0)
  end
end
