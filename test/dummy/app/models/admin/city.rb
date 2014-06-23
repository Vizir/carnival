module Admin
  class City < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "cities"
    belongs_to :country
    belongs_to :state
    validates_presence_of :name

    scope :national, -> {joins(:country).where("countries.code = ?", "BR")}
    scope :international, -> {joins(:country).where("countries.code <> ?", "BR")}
  end
end
