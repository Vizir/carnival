module Admin
  class ProfessionalExperience < ActiveRecord::Base
    include AssociationCommon
    self.table_name = "professions"

    belongs_to :people
    belongs_to :company
    belongs_to :job

    def list_for_select(params = {})
      all.collect{|c|[c.to_s, c.id]}
    end
  end
end
