require 'rails_helper'

feature "user navigates to carnival root path" do
  scenario "successfully" do
    visit carnival_root_path
  end
end
