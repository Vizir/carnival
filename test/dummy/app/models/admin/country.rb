module Admin
  class Country < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "countries"

    has_many :states
    has_many :cities
  end
end
