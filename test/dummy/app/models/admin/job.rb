module Admin
  class Job < ActiveRecord::Base
    include AssociationCommon
    self.table_name = "jobs"

    has_many :professional_experiences
    has_many :companies, :through => :professional_experiences
    has_many :people, :through => :professional_experiences
  end
end
