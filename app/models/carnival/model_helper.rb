module Carnival::ModelHelper

  def to_label
    self.respond_to?(:name) ? self.name : self.to_s
  end

  def self.included mod
    mod.extend ClassMethods
  end

  module ClassMethods
    def list_for_select(params = {})
      select = []
      select << ['', ''] if params[:add_empty_option]
      if params[:reverse]
        select.concat all.collect{|c|[c.to_label, c.id]}
      else
        select.concat all.collect{|c|[c.id, c.to_label]}
      end
      select
    end

    def list_for_checkbox
      list = []
      all.each {|object| list << [object.id, object.to_label] }
      list
    end
  end
end
