module Admin
  class PersonHistory < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "person_histories"
    belongs_to :person
  end
end
