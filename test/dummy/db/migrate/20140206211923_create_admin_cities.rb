class CreateAdminCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.references :country, index: true
      t.references :state, index: true

      t.timestamps
    end
  end
end
