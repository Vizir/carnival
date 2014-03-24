class CreateAdminCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.references :country, index: true
      t.references :state, index: true
      t.references :city, index: true
      t.string :address
      t.string :address_complement
      t.string :number
      t.integer :zipcode

      t.timestamps
    end
  end
end
