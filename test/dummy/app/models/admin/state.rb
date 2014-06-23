module Admin
  class State < ActiveRecord::Base
    include Carnival::ModelHelper
    self.table_name = "states"

    belongs_to :country
    has_many :cities

    validates_presence_of :name
    validates_presence_of :code
    validates_uniqueness_of :code

    accepts_nested_attributes_for :cities, :reject_if => :all_blank, :allow_destroy => true
    scope :national, -> {joins(:country).where("countries.code = ?", "BR")}
    scope :international, -> {joins(:country).where("countries.code <> ?", "BR")}
  end
end
