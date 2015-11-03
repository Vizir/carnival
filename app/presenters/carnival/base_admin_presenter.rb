# -*- encoding : utf-8 -*-
module Carnival
  class BaseAdminPresenter
    DEFAULT_CSV_RECORDS_PER_CHUNK = 500
    include Dsl
    include Rails.application.routes.url_helpers

    def initialize
      return unless model_class.present?

      @klass_service = KlassService.new model_class
      @advanced_search_parser = Presenters::AdvancedSearchParser.new(@klass_service)
      @validators = [Carnival::PresenterValidators::FieldValidator]
      validates
    end

    def validates
      @validators.each do |validator|
        validator.new(self).validates
      end
    end

    def presenter_name
      self.class.to_s
    end

    def has_batch_actions?
      if @@batch_actions[presenter_class_name].present?
        @@batch_actions[presenter_class_name].keys.size > 0
      else
        false
      end
    end

    def items_per_page
      @@items_per_page[presenter_class_name] ||= {}
      unless @@items_per_page[presenter_class_name][:items_per_page].present? and @@items_per_page[presenter_class_name][:items_per_page] > 0
        @@items_per_page[presenter_class_name][:items_per_page] = Carnival::Config.items_per_page
      end
      @@items_per_page[presenter_class_name][:items_per_page]
    end

    [:table, :list, :grid].each do |index_type|
      define_method "index_as_#{index_type}?" do
        index_as == index_type
      end
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
      if @@forms[presenter_class_name].present? &&
         @@forms[presenter_class_name][action].present?
        form =  @@forms[presenter_class_name][action]
      else
        form = Carnival::Form.new(action)
      end
      form.fields = fields_for_action(action)
      form
    end

    def model_name
      if @@model_names[presenter_class_name].nil?
        self.class.to_s.split('::').last.gsub('Presenter', '').underscore
      else
        if @@model_names[presenter_class_name].include?('/')
          @@model_names[presenter_class_name].split('/').last
        else
          @@model_names[presenter_class_name]
        end
      end
    end

    def model_params(params)
      params.select { |key, _| key != 'action' && key != 'controller' }
    end

    def model_path(action, extra_params = {})
      params = extra_params.reverse_merge(
        controller: controller_name, action: action
      ).merge(only_path: true)
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
      "#{controller_name}_controller".classify
    end

    def controller_name
      if is_namespaced?
        "#{extract_namespace}/#{controller_resource_name}".underscore
      else
        controller_resource_name
      end
    end

    def table_name
      model_class.table_name
    end

    def join_tables
      @@fields[presenter_class_name].map do |key, field|
        field.association_name if relation_field? key.to_sym
      end
    end

    def render_field?(field, action = nil)
      true
    end

    def render_action?(record, record_action, action = nil)
      true
    end

    def build_relation_field(field, model_object)
      if is_relation_belongs_to?(field.name)
        model_object.send("#{field.name}_build")
      else
        model_object.send(field.name).build
      end
    end

    def must_render_field?(nested_in, field, model_object)
      return true unless nested_in.present?
      if field.as == :partial
        true
      elsif nested_in.class == model_object.send(field.name).class ||
            nested_in.class.name.underscore.split('/').last == field.name
        false
      else
        true
      end
    end

    def default_scope
      return if scopes.empty?
      @@scopes[presenter_class_name].values.find(&:default?) ||
        @@scopes[presenter_class_name].values.first
    end

    def default_sortable_field
      @@fields[presenter_class_name].values.find(&:default_sortable?) ||
        @@fields[presenter_class_name].values.first
    end

    def default_sort_direction
      default_sortable_field.default_sort_direction
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
      if related.present?
        if is_one_to_one_relation?(field)
          params = { controller: "#{extract_namespace.downcase}/#{relation_name}", action: :show, id: related.id }
        else
          params = { controller: "#{extract_namespace.downcase}/#{get_association_from_field(field)}", action: :index, advanced_search: make_relation_advanced_query_url_options(field.name, record) }
        end
        params = params.merge(only_path: true)
        generate_route_path params
      else
        '#'
      end
    end

    def get_related_class_for_field(field_name)
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

    def related_presenter(field, _not_used = nil)
      field = get_field(field)
      if field.presenter_class.present?
        field.presenter_class.constantize.new
      else
        infer_presenter(field)
      end
    end
    alias_method :presenter_to_field, :related_presenter

    def controller_to_field(field)
      "#{extract_namespace}::#{field.name.to_s.classify.pluralize}Controller".constantize.new
    end

    def load_dependent_select_options_path
      if extract_namespace.present?
        "/#{extract_namespace.downcase}/carnival-base/load_dependent_select_options"
      else
        '/carnival-base/load_dependent_select_options'
      end
    end

    def render_field(field_name, record)
      renderer_for(field_name).render_field(record)
    end

    def renderer_for(field_name)
      FieldRenderers::RendererCreator.create_field_renderer(self, field_name)
    end

    def translate_field field_name
      field = get_field(field_name)
      if field.specified_association?
        related_class = model_class.reflect_on_association(field.association_name.to_sym).klass
        related_class.human_attribute_name(field.association_field_name)
      else
        field_key = field.name_for_translation
        model_class.human_attribute_name field_key
      end
    end

    def csv_records_per_chunk
      @@csv_records_per_chunk[presenter_class_name] ||
        DEFAULT_CSV_RECORDS_PER_CHUNK
    end

    def csv_for_record(record)
      CSV.generate do |csv|
        csv << fields_for_action(:csv).keys.map do |field|
          render_field(field, record)[:value]
        end
      end
    end

    def csv_for_header
      CSV.generate(headers: :first_row) do |csv|
        csv << fields_for_action(:csv).keys
      end
    end

    protected

    def infer_presenter(field)
      related_presenter_name =
        get_related_class(field.association_name)
        .gsub(/.*[(::)\/]/, '')
      "#{extract_namespace}::#{related_presenter_name.singularize.classify}Presenter".constantize.new
    end

    def make_relation_advanced_query_url_options(field, record)
      relation_model = @klass_service.get_association(field).klass.name.pluralize.underscore.split("/").last
      relation_field = @klass_service.get_association(field).foreign_key
      relation_value = record.id
      { "#{relation_model}.#{relation_field}" => relation_value }
    end

    def filter_actions(default_actions, target)
      actions = {}
      return actions unless @@actions[presenter_class_name]

      @@actions[presenter_class_name].each do |key, action|
        if default_actions.include?(key) || (action.target == target && key != :new && key != :csv)
          actions[key] = action
        end
      end
      actions
    end

    def self.presenter_class_name
      if self.class.name == 'Class'
        to_s
      else
        self.class.name
      end
    end

    def presenter_class_name
      self.class.presenter_class_name
    end

    def controller_resource_name
      presenter_class_name
        .demodulize
        .gsub('Presenter', '')
        .underscore
        .pluralize
    end

    def is_namespaced?
      extract_namespace.present?
    end

    def extract_namespace
      self.class.to_s.deconstantize
    end

    def generate_route_path(params)
      url_for(params) rescue nil
    end
  end
end
