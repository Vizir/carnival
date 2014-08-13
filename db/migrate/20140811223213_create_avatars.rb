class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.attachment :photo
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
