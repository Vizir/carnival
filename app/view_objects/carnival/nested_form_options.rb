module Carnival
  
  class NestedFormOptions
    include Rails.application.routes.url_helpers

    def initialize(model, presenter, field)
      @model = model
      @presenter = presenter
      @field = field
      @available_options = []
      @model_fields_ids = []
      init
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
      scope = @field.nested_form_scope
      return null if !model.reflections[scope]
      fkey = model.reflections[scope].foreign_key
      return make_html_field_for fkey
    end

    def make_html_id_for(elem)
      first = model.class.name.gsub(/::/, '_').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase 
      "#{first}_#{elem}"
    end

    private
    def init
      populate_available_options
      populate_model_items
    end

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
