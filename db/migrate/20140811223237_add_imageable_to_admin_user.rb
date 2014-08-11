class AddImageableToAdminUser < ActiveRecord::Migration
  def change
    add_reference :admin_users, :imageable, index: true
  end
end
