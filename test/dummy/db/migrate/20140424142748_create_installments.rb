class CreateInstallments < ActiveRecord::Migration
  def change
    create_table :installments do |t|
      t.string :name

      t.timestamps
    end
  end
end
