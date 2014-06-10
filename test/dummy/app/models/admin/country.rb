module Admin
  class Country < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "countries"

    has_many :states
    has_many :cities

    accepts_nested_attributes_for :states, :reject_if => :all_blank, :allow_destroy => true
    accepts_nested_attributes_for :cities, :reject_if => :all_blank, :allow_destroy => true

    def to_label
      name
    end
  end
end
