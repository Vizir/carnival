module Admin
  class Person < ActiveRecord::Base
    self.table_name = "people"

    belongs_to :company
    belongs_to :country
    belongs_to :state
    belongs_to :city
    has_one :person_history
    has_many :professional_experiences
    has_many :companies, :through => :professional_experiences
    has_many :jobs, :through => :professional_experiences

    accepts_nested_attributes_for :person_history, :reject_if => :all_blank, :allow_destroy => true
    accepts_nested_attributes_for :state, :reject_if => :all_blank, :allow_destroy => true
    scope :employed, -> {where("employed = ?", true)}
    scope :unemployed, -> {where("employed = ?", false)}

  end
end
