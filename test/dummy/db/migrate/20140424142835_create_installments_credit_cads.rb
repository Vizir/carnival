class CreateInstallmentsCreditCads < ActiveRecord::Migration
  def change
    create_table :installments_credit_cads do |t|
      t.references :installment, index: true
      t.references :credit_card, index: true

      t.timestamps
    end
  end
end
