class CreatePersonHistories < ActiveRecord::Migration
  def change
    create_table :person_histories do |t|
      t.references :person, index: true
      t.text :history
      t.timestamps
    end
  end
end
