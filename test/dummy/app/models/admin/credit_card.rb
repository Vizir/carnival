module Admin
  class CreditCard < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "credit_cards"
    
    has_many :installments_credit_cads
    has_many :installments, through: :installments_credit_cads
  end
end