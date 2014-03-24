module Admin
  class Country < ActiveRecord::Base
    include AssociationCommon
    self.table_name = "countries"

    has_many :states
    has_many :cities
  end
end
