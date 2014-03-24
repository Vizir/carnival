class CreateAdminStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :code

      t.references :country, index: true

      t.timestamps
    end
  end
end
