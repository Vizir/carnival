# This migration comes from carnival_engine (originally 20140129223355)
class CreateAdminUserNotifications < ActiveRecord::Migration
  def change
    create_table :admin_user_notifications do |t|
      t.boolean :read, default: false
      t.references :notification, index:true
      t.references :admin_user, index:true
      t.timestamps
    end
  end
end
