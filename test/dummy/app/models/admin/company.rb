module Admin
  class Company < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "companies"

    belongs_to :country
    belongs_to :state
    belongs_to :city
    has_many :professional_experiences
    has_many :people, :through => :professional_experiences
    has_many :jobs, :through => :professional_experiences

  end
end
