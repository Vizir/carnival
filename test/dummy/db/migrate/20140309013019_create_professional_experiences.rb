class CreateProfessionalExperiences < ActiveRecord::Migration
  def change
    create_table :professional_experiences do |t|
      t.references :people, index: true
      t.references :company, index: true
      t.references :job, index: true
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :finished_status

      t.timestamps
    end
  end
end
