# -*- encoding : utf-8 -*-
module Carnival
  class BaseAdminPresenter
    include Rails.application.routes.url_helpers

    def initialize(params)
      @controller = params[:controller]

      if model_class.present?
        @klass_service = KlassService.new model_class
        @advanced_search_parser = Presenters::AdvancedSearchParser.new(@klass_service)
        @validators = [Carnival::PresenterValidators::FieldValidator]
        validates
      end
    end

    def validates
      @validators.each do |validator|
        validator.new(self).validates
      end
    end

    def presenter_name
      self.class.to_s
    end

    @@index_as = {}
    def self.index_as(type)
      @@index_as[presenter_class_name] = type
    end

    @@actions = {}
    def self.action(name, params = {})
      @@actions[presenter_class_name] ||= {}
      @@actions[presenter_class_name][name] = Carnival::Action.new(name, params)
    end

    @@batch_actions = {}
    def self.batch_action(name, params = {})
      @@batch_actions[presenter_class_name] ||= {}
      @@batch_actions[presenter_class_name][name] = Carnival::BatchAction.new(self.new({}), name, params)
    end

    def has_batch_actions?
      if @@batch_actions[presenter_class_name].present?
        @@batch_actions[presenter_class_name].keys.size > 0
      else
        false
      end
    end

    @@items_per_page = {}
    def self.items_per_page(per_page)
      @@items_per_page[presenter_class_name] ||= {}
      @@items_per_page[presenter_class_name][:items_per_page] = per_page
    end

    def items_per_page
      @@items_per_page[presenter_class_name] ||= {}
      unless @@items_per_page[presenter_class_name][:items_per_page].present? and @@items_per_page[presenter_class_name][:items_per_page] > 0
        @@items_per_page[presenter_class_name][:items_per_page] = Carnival::Config.items_per_page
      end
      @@items_per_page[presenter_class_name][:items_per_page]
    end

    def index_as_table?
      index_as == :table
    end

    def index_as_list?
      index_as == :list
    end

    def index_as_grid?
      index_as == :grid
    end

    def index_as
      @@index_as[presenter_class_name] ||= :table
    end

    def actions
      @@actions[presenter_class_name]
    end

    def batch_actions
      @@batch_actions[presenter_class_name]
    end

    def actions_for_record
      filter_actions([:show, :edit, :destroy], :record)
    end

    def actions_for_page
      filter_actions([:new], :page)
    end

    def has_action?(action)
      @@actions[presenter_class_name].present? && @@actions[presenter_class_name][action].present?
    end

    @@model_names = {}
    @@fields = {}
    @@scopes = {}
    @@forms = {}

    def scopes
      @@scopes[presenter_class_name] || {}
    end

    def fields
      @@fields[presenter_class_name]
    end

    def get_field(field)
      if field.respond_to? :to_sym
        @@fields[presenter_class_name][field.to_sym]
      else
        field
      end
    end

    def fields_for_action(action)
      fields_action = {}
      @@fields[presenter_class_name].each do |key, field|
        if field.valid_for_action?(action)
          fields_action[key] = field
        end
      end
      fields_action
    end

    def form_for(action)
      form = Carnival::Form.new(action)
      form =  @@forms[presenter_class_name][action] if @@forms[presenter_class_name].present? and  @@forms[presenter_class_name][action].present?
      form.fields = fields_for_action(action)
      form
    end


    def model_name
      if @@model_names[presenter_class_name].nil?
        self.class.to_s.split("::").last().gsub("Presenter", "").underscore
      else
        if @@model_names[presenter_class_name].include?("/")
          @@model_names[presenter_class_name].split("/").last
        else
          @@model_names[presenter_class_name]
        end
      end
    end

    def model_params(params)
      params.select{|key, value| key != "action" && key != "controller"}
    end

    def model_path(action, extra_params=nil)
      params = {controller: controller_name, action: action}
      params = params.merge(extra_params) if extra_params.present?
      params = params.merge(:only_path => true)
      url_for(params)
    end

    def is_from_carnival?
      self.class.to_s.include? 'Carnival::'
    end

    def full_model_name
      if Carnival::Config.use_full_model_name == false and !is_from_carnival?
        return model_name
      end

      if @@model_names[presenter_class_name].nil?
        self.class.to_s.gsub("Presenter", "").underscore
      else
        @@model_names[presenter_class_name]
      end
    end

    def controller_class_name
      @controller.class.name
    end

    def controller_name
      namespace = extract_namespace
      if namespace.present?
        "#{extract_namespace.downcase}/#{@controller.controller_name}"
      else
        @controller.controller_name
      end
    end

    def table_name
      model_class.table_name
    end

    def searchable_fields
      searchable_fields = {}
      @@fields[presenter_class_name].each do |key, field|
        if relation_field? key
          field_name = "#{field.name.pluralize}.name"
        else
          field_name = "#{self.table_name}.#{field.name}"
        end
        searchable_fields[field_name] = field if field.searchable?
      end
      searchable_fields
    end

    def join_tables
      joins = []
      @@fields[presenter_class_name].each do |key, field|
        joins << field.association_name if relation_field? key.to_sym
      end
      joins
    end

    def render_field?(field, action = nil)
      return true
    end

    def render_action?(record, record_action, action = nil)
      return true
    end

    def build_relation_field(field, model_object)
      if is_relation_belongs_to?(field.name)
        model_object.send("#{field.name}_build")
      else
        model_object.send(field.name).build
      end
    end

    def must_render_field?(nested_in, field, model_object)
      must_render = true
      if nested_in.present?
        if field.as == :partial
          must_render = true
        elsif nested_in.class == model_object.send(field.name).class
          must_render = false
        elsif nested_in.class.name.underscore.split("/").last == field.name
          must_render = false
        end
      end
      return must_render
    end

    def default_scope
      return if scopes.empty?
      @@scopes[presenter_class_name].each do |key, scope|
        return scope if scope.default?
      end
      @@scopes[presenter_class_name].values.first
    end

    def default_sortable_field
      default_field = nil
      @@fields[presenter_class_name].each do |key, field|
        default_field = field if field.default_sortable?
        break
      end
      default_field = @@fields[presenter_class_name].first[1] if default_field.nil?
      default_field
    end

    def default_sort_direction
      default_sortable_field.default_sort_direction
    end

    def sortable_fields
      sortable_fields = {}
      @@fields[presenter_class_name].each do |key, field|
        sortable_fields[key] = field if field.sortable?
      end
      sortable_fields
    end

    def advanced_search_fields
      fields = @@fields[presenter_class_name]
      @advanced_search_parser.get_advanced_search_fields fields
    end

    def date_filter_field
      date_field = nil
      @@fields[presenter_class_name].each do |key, field|
        if field.date_filter?
          date_field = field
          break
        end
      end
      date_field
    end

    def model_class
      full_model_name.classify.constantize rescue nil
    end

    def relation_field?(field_name)
      field = get_field(field_name)
      if field.present?
        field.specified_association? or @klass_service.relation?(field.name)
      else
        false
      end
    end

    def get_association(association)
      @klass_service.get_association(association)
    end

    def relation_type sym
      @klass_service.relation_type sym
    end

    def is_relation_belongs_to?(field)
      model_class.reflect_on_association(field.to_sym).macro == :belongs_to
    end

    def is_relation_has_many?(field)
      field = get_field(field)
      association = @klass_service.relation_type(field.association_name || field.name)
      association.to_s.include? 'many'
    end

    def field_type(field)
      type = model_class.columns_hash[field.to_s].try(:type)
      if relation_field?(field.to_sym) then :relation
      elsif type == :date || type == :datetime then type
      elsif type == :number || type == :float then :number
      elsif type == :integer and model_class.const_defined? field.upcase and field != :id then :enum
      else type
      end
    end

    def relation_model(field)
      field = get_field(field)
      @klass_service.get_association(field.association_name).klass
    end

    def is_one_to_one_relation?(field_name)
      field = get_field(field_name)
      @klass_service.is_a_belongs_to_relation?(field.association_name) ||
        @klass_service.is_a_has_one_relation?(field.association_name)
    end

    def relation_path(field, record)
      field = get_field(field)
      return nil if !relation_field?(field)
      relation_name = get_related_class_for_field(field)
      related = record.send(field.association_name)
      unless related.nil?
        if is_one_to_one_relation?(field)
          params = {:controller =>  "#{extract_namespace.downcase}/#{relation_name}", :action => :show, :id => related.id}
        else
          params = {:controller => "#{extract_namespace.downcase}/#{get_association_from_field(field)}", :action => :index, :advanced_search => make_relation_advanced_query_url_options(field.name, record)}
        end
        params = params.merge(:only_path => true)
        return generate_route_path params
      else
        '#'
      end
    end

    def get_related_class_for_field (field_name)
      get_related_class get_association_from_field(field_name)
    end

    def get_association_from_field(field)
      field = get_field(field)
      field.specified_association? ? field.association_name : field.name
    end

    def get_related_class relation_name
      @klass_service.related_class_file_name relation_name
    end

    def get_class_for field
      @klass_service.related_class field
    end

    def parse_advanced_search records, search_syntax
      @advanced_search_parser.parse_advanced_search @@fields[presenter_class_name], records, search_syntax
    end

    def presenter_to_field field, record
      "#{extract_namespace}::#{field.name.to_s.singularize.classify}Presenter".constantize.send("new", :controller => controller_to_field(field))
    end

    def presenter_to_field_sym field
      "#{extract_namespace}::#{field.to_s.singularize.classify}Presenter".constantize.send("new", :controller => controller_to_field_sym(field))
    end

    def controller_to_field field
      "#{extract_namespace}::#{field.name.to_s.classify.pluralize}Controller".constantize.send("new")
    end

    def controller_to_field_sym field
      "#{extract_namespace}::#{field.to_s.classify.pluralize}Controller".constantize.send("new")
    end
    def load_dependent_select_options_path
      if extract_namespace.present?
        "/#{extract_namespace.downcase}/carnival-base/load_dependent_select_options"
      else
        "/carnival-base/load_dependent_select_options"
      end
    end

    protected
    def make_relation_advanced_query_url_options(field, record)
      relation_model = @klass_service.get_association(field).klass.name.pluralize.underscore.split("/").last
      relation_field = @klass_service.get_association(field).foreign_key
      relation_value = record.id
      {"#{relation_model}.#{relation_field}" => relation_value}
    end

    def filter_actions(default_actions, target)
      actions = {}
      return actions if !@@actions[presenter_class_name]

      @@actions[presenter_class_name].each do |key, action|
        if default_actions.include?(key) || (action.target == target && key != :new && key != :csv && key != :pdf)
          actions[key] = action
        end
      end
      actions
    end

    def presenter_class_name
      if self.class.name == "Class"
        self.to_s
      else
        self.class.name
      end
    end

    def is_namespaced?
      self.class.to_s.split("::").size > 0
    end

    def extract_namespace
      namespace = ""
      arr = self.class.to_s.split("::")
      namespace = arr[0] if arr.size > 1
      namespace
    end

    def self.instantiate_element(container, klass, name, params)
      container[presenter_class_name] ||= {}
      container[presenter_class_name][name] = klass.new(name, params)
    end

    def self.scope(name, params = {})
      self.instantiate_element(@@scopes, Carnival::Scope, name.to_sym, params)
    end

    def self.field(name, params = {})
      self.instantiate_element(@@fields, Carnival::Field, name.to_sym, params)
    end

    def self.form(action, params = {})
      self.instantiate_element(@@forms, Carnival::Form, name.to_sym, params)
    end

    def self.model_name(name)
      @@model_names[presenter_class_name] = name
    end

    def generate_route_path params
      url_for(params) rescue nil
    end

    def self.presenter_class_name
      if self.class.name == "Class"
        self.to_s
      else
        self.class.name
      end
    end

    def current_user
      return @controller.current_user if @controller.respond_to?(:current_user)
      nil
    end
  end
end
