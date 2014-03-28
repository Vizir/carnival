module Admin
  class Job < ActiveRecord::Base
    include Carnival::ModelHelper
    has_many :professional_experiences
    has_many :companies, :through => :professional_experiences
    has_many :people, :through => :professional_experiences
  end
end
