module Carnival

  class NestedFormOptions
    include Rails.application.routes.url_helpers


    def initialize(model, presenter, field, items = nil)
      @model = model
      @presenter = presenter
      @field = field
      @available_options = items
      @model_fields_ids = []
      populate_model_items
      populate_available_options if items.nil?
    end

    def field
      @field
    end

    def field_name
      @field.name
    end

    def available_options
      @available_options
    end

    def has_new_action?
      @field.nested_form_modes?(:new)
    end

    def model_has_this_item? id
      @model_fields_ids.include? id
    end

    def model_class_name_underscore
      @model.class.name.underscore.gsub('/', '_')
    end

    def field_name_identifier
      self.field_name.singularize.to_sym
    end

    def option_name
      model_id = self.model_class_name_underscore
      field_id = self.field_name_identifier
      "#{model_id}[#{field_id}_ids][]"
    end

    def option_id item_option
      model_id = self.model_class_name_underscore
      field_id = self.field_name_identifier
      "#{model_id}_#{field_id}_ids_#{item_option.id}"
    end

    def option_css_class item
      return "carnival-form-options-hide" if !self.model_has_this_item?(item.id)
    end

    def select_tag_id
      "carnival-options-select-#{self.field_name_identifier}"
    end

    def check_box_html

    end

    def select_options
      options = []
      @available_options.each do |item|
        props = {}
        id = self.option_id(item)
        props[:id] = "#{id}_select_option"
        props[:disabled] = self.model_has_this_item?(item.id)
        options << [item.to_label, id, props]
      end
      options
    end

    def scope_html_id
      make_html_id_for scope_column_name
    end

    def scope_column_name
      scope = @field.nested_form_scope
      return nil if !@model.reflections[scope]
      fkey = @model.reflections[scope].foreign_key
    end

    def scopeJSFunction
      url = "#{@presenter.model_path(:index)}.json"
      function_params = {}
      function_params[:url] = url
      function_params[:list_scope] = true
      function_params[:model_class_name] = @model.class.name
      function_params[:model_id] = @model.id
      function_params[:field_name] = @field.name
      function_params[:scope_name] = scope_column_name
      function_params[:scope_html_id] = scope_html_id
      function_params[:presenter_name] = @presenter.class.name
      function_params[:controller_name] = @presenter.controller_class_name

      "getNestedFormOptions(#{function_params.to_json});"
    end

    def make_html_id_for(elem)
      first = @model.class.name.gsub(/::/, '_').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
      "#{first}_#{elem}"
    end

    private

    def populate_model_items
      list = @model.send(self.field_name)
      @model_fields_ids = list.map {|i| i.id}
    end

    def populate_available_options
      scopes = []
      scopes << @field.nested_form_scope if @field.nested_form_scope.present?
      carnival_scope = {carnival_scope: {scopes: scopes, model_object: @model}}
      field_presenter = @presenter.presenter_to_field(@field, nil)
      model_class = field_presenter.model_class
      @available_options = model_class.get_elements_for_select(carnival_scope)
    end

  end

end
