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
        item.const_get(field.to_s.upcase).present?
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

    def has_many_relation? model, field
      klass = Carnival::KlassService.new model.class
      klass.is_a_has_many_relation?(field.to_sym)
    end

    def has_one_relation? model, field
      klass = Carnival::KlassService.new model.class
      klass.is_a_has_one_relation?(field.to_sym)
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
      return :relation if presenter.relation_field?(field.to_sym)
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

    def show_view(presenter, field)
      presenter.fields[field.to_sym].show_view
    end

    def show_as_list(presenter, field)
      current_type = field_type(presenter,field)
      return false if current_type != :relation
      return presenter.fields[field.to_sym].show_as_list
    end

    def field_to_show(presenter, field, record, show_only_value=false)
      current_type = field_type(presenter,field)
      if current_type.to_s.include?'relation'
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

    def list_cel(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      td = "<td class='first-td'>"
      return "#{td}<span class='#{get_css_class(presenter, field, record)}'>#{result}</span></td>" if presenter.fields[field].css_class.present?
      "#{td}#{result}</td>"
    end

    def get_css_class presenter, field, record
      css_class = presenter.fields[field].css_class
      return '' if !css_class
      return record.send(css_class[:method]) if css_class.is_a? Hash 
      return css_class if css_class.is_a? String
      return ''
    end

    def list_buttons(presenter, record)
      result = ""
      presenter.actions_for_record.each do |key, action|
        if action.show(record)
          if action.remote?
            result << button_action_remote(action, presenter, record)
          else
            result << button_action(action, presenter, record)
          end
        end
      end
      result
    end

    def button_action(action, presenter, record)
      label =  t("#{presenter.model_name}.#{action.name}", default: t("carnival.#{action.name}"))
      path = action.path(:id => record.id)
      if action.default_partial == :default
        "<a class='action editar' href='#{path}'>#{label}</a>"
      elsif action.default_partial == :delete
        confirm = I18n.t("are_you_sure")
        "<a class='action apagar' data-confirm='#{confirm}' data-method='delete' href='#{path}' rel='nofollow'>#{label}</a>"
      end
    end

    def button_action_remote(action, presenter, record)
      name = action.name
      params = action.params
      label =  t("#{presenter.model_name}.#{action.name}", default: t("carnival.#{action.name}"))
      path = action.path(:id => record.id)

      success_callback = "#{name}_success_callback" 
      if params[:success]
        success_callback = params[:success]
      end

      error_callback = "#{name}_error_callback" 
      if params[:error]
        error_callback = params[:error]
      end

      remote_function = "Carnival.remoteFunction(\"#{path}\", \"#{success_callback}\", \"#{error_callback}\", \"#{params[:method]}\")"

      "<a class='editar' href='#' onclick='#{remote_function}'>#{label}</a>"
    end

  end
end
