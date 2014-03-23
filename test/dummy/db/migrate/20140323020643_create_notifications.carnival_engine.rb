# This migration comes from carnival_engine (originally 20140129213216)
class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :message
      t.string :link
      t.timestamps
    end
  end
end
