module Admin
  class ProfessionalExperience < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "professional_experiences"

    belongs_to :people, :foreign_key => 'people_id'
    belongs_to :company
    belongs_to :job

    def list_for_select(params = {})
      all.collect{|c|[c.to_s, c.id]}
    end
  end
end
