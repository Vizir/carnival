module Admin
  class City < ActiveRecord::Base
    include AssociationCommon
    self.table_name = "cities"
    belongs_to :country
    belongs_to :state

    scope :national, -> {includes(:country).where("countries.code = ?", "BR")}
    scope :international, -> {includes(:country).where("countries.code <> ?", "BR")}
  end
end
