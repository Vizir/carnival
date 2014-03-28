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
  end
end
