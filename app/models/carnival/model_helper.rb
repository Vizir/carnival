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
      query = all
      query = query.where(params[:query]) if params[:query].present?
      if params[:reverse]
        select.concat query.collect{|c|[c.to_label, c.id]}
      else
        select.concat query.collect{|c|[c.id, c.to_label]}
      end
      select
    end

    def list_for_checkbox
      list = []
      all.each {|object| list << [object.id, object.to_label] }
      list
    end

    def get_elements_for_select(params = {})
      return all if params[:carnival_scope].nil?
      scopes = params[:carnival_scope][:scopes]
      return all if scopes.empty?
      model_object = params[:carnival_scope][:model_object]
      conditions = {}
      scopes.each do |scp|
        value = model_object.send scp
        conditions[scp] = value if !value.nil?
      end
      return where(conditions) if !conditions.empty?
      []
    end
  end
end
