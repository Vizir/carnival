class AddColumnsToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :provider, :string
    add_column :admin_users, :uid, :string
    add_column :admin_users, :avatar, :string
  end
end
