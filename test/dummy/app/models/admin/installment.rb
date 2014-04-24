module Admin
  class Installment < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "installments"

    has_many :installments_credit_cads, class_name: "Admin::InstallmentsCreditCads"
    has_many :credit_cards, through: :installments_credit_cads

    accepts_nested_attributes_for :credit_cards, :reject_if => :all_blank, :allow_destroy => true
  end
end
