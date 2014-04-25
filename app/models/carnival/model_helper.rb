module Carnival::ModelHelper

  def to_s
    self.name
  end

  def self.included mod
    mod.extend ClassMethods
  end

  module ClassMethods
    def list_for_select(params = {})
      select = []
      select << ['', ''] if params[:add_empty_option]
      if params[:reverse]
        select.concat all.collect{|c|[c.to_s, c.id]}
      else
        select.concat all.collect{|c|[c.id, c.to_s]}
      end
      select
    end

     def to_label_options
      label = column_names.select { |column| column.eql?("name")}
      label.empty? ?  column_names.fetch(1).to_sym : label.first.to_sym
    end
  end
end
