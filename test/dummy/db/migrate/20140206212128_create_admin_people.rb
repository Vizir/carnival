class CreateAdminPeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.datetime :dob
      t.references :country, index: true
      t.references :state, index: true
      t.references :city, index: true
      t.string :address
      t.string :address_complement
      t.string :number
      t.integer :zipcode
      t.boolean :employed

      t.timestamps
    end
  end
end
