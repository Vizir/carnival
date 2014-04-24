module Admin
  class InstallmentsCreditCads < ActiveRecord::Base
    self.table_name = "installments_credit_cads"
    belongs_to :installment
    belongs_to :credit_card
  end
end
