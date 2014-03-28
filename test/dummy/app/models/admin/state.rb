module Admin
  class State < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "states"

    belongs_to :country
    has_many :cities

    scope :national, -> {includes(:country).where("countries.code = ?", "BR")}
    scope :international, -> {includes(:country).where("countries.code <> ?", "BR")}
  end
end
