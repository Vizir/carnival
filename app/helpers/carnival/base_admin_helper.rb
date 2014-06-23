module Carnival
  module BaseAdminHelper
    def set_resource_actived_if_current(path)
      (request.fullpath == path)? 'actived' : ''
    end

    def show_messages
      @messages = ''
      flash.each do |type, message|
        @messages = message
        @type = type
      end
      javascript = "noty({'text':'#{@messages}',
            'layout':'bottom','type':'#{@type}',
            'animation': {'close':{'height':'toggle'}, 'open':{'height':'toggle'},'speed':500},'timeout':4000,
            'closeWith':['click', 'hover']});"
      return javascript if defined?(@type)
      ''
    end

    def link_to_add_fields(name, f, association, path="")
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, [new_object], :child_index => "new_#{association}") do |builder|
        render(path + association.to_s.singularize + "_fields", :f => builder)
      end
      fields = fields.gsub("\"","'").gsub("&",'&amp;').gsub("<",'&lt;').gsub(">",'&gt;').gsub("\n", '')
      link_to_function(name, ("addFields(this, '#{association}', \"#{raw(fields)}\")"))
    end

    def link_to_remove_fields(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "removeFields(this)")
    end

    def caminho_modelo(action, extra_params=nil)
      params = {controller: controller.controller_name, action: action}
      params = params.merge(extra_params) if extra_params.present?
      url_for(params)
    end

    def constant_exists?(item, field)
      begin
        item.class.const_get(field.to_s.upcase).present?
      rescue
        false
      end
    end
    
    def carnival_render_if_exist partial_path
      if partial_exist?(partial_path)
        return render partial_path
      end
    end

    def partial_exist? partial_path
      File.exists?(get_partial_path(partial_path))
    end

    def get_partial_path partial_path
      path = Rails.root.join('app', 'views')
      partial_path_array = partial_path.split('/')
      partial_path_array.each do |pp|
        if pp == partial_path_array.last
          path = path.join "_#{pp}.html.haml"
        else
          path = path.join pp
        end
      end
      path
    end

    def field_type(presenter,field)
      if presenter.relation_field?(field.to_sym)
        relation =  presenter.relation_type field.to_sym 
        return ("#{relation.to_s}_relation").to_sym
      end
      field_type = nil
      field_type = presenter.model_class.columns_hash[field.to_s].type if presenter.model_class.columns_hash[field.to_s].present?
      return :date if field_type == :datetime or field_type == :date
      return :number  if field_type == :decimal or field_type == :float
      return :enum if field_type == :integer and constant_exists?(presenter.model_class,field)
      :other
    end

    def menu_link link
      link.strip!
      if link.to_s.end_with?('_path') or link.to_s.end_with?('_url')
        return eval link 
      elsif link.index(/_path.+/) #path with arguments
        return eval link 
      end

      link
    end

    def field_to_show(presenter, field, record, show_only_value=false)
      current_type = field_type(presenter,field)
      if current_type.to_s.include?'_relation'
        if show_only_value
          record.send(field.to_s).to_label unless record.send(field.to_s).nil?
        else
          return link_to presenter.relation_label(field.to_sym, record), presenter.relation_path(field.to_sym, record)
        end
      else
        result = record.send(field.to_s)
        if current_type == :date
          if result.nil?
            return result
          else
            return result.strftime("%d/%m/%y %H:%M:%S")
          end
        end
        return number_with_precision(result, :precision => 2, :separator => ",") if current_type == :number
        return record.class.const_get(field.to_s.upcase)[result] if current_type == :enum
        result
      end
    end
  end
end
