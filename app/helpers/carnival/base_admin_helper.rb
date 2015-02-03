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

    def caminho_modelo(action, extra_params=nil)
      params = {controller: controller.controller_name, action: action}
      params = params.merge(extra_params) if extra_params.present?
      url_for(params)
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

    def many_to_many_relation? model, field
      klass = Carnival::KlassService.new model.class
      klass.is_a_many_to_many_relation?(field.to_sym)
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
      presenter.get_field(field).show_view
    end

    def show_as_list(presenter, field)
      current_type = presenter.field_type(field)
      if current_type != :relation
        false
      else
        presenter.get_field(field).show_as_list
      end
    end

    def field_to_show(presenter, field_name, record, show_only_value=false)
      rendered = field_value_and_type presenter, field_name, record
      field_type = rendered[:field_type]
      value = rendered[:value]
      
      is_relation = presenter.relation_field?(field_name)

      unless value.nil?
        formatted_field = format_field(presenter, field_name, field_type, value)
        if is_relation and !show_only_value
          link_to(formatted_field, presenter.relation_path(field_name, record))
        else
          formatted_field
        end
      else
        nil
      end
    end

    def field_value_and_type presenter, field_name, record
      renderer = FieldRenderers::RendererCreator
        .create_field_renderer(presenter, field_name)

      rendered = renderer.render_field(record)
    end

    def is_image? field_type, value
      field_type.nil? and value.class.to_s == "Paperclip::Attachment" and value.content_type.include? "image"
    end

    def format_field(presenter, field_name, field_type, value)
      if is_image?(field_type, value)
        "<img class='attr' src='#{value.url(:thumb)}' alt='#{translate_field(presenter, field_name)}' />"
      else
        case field_type
        when :datetime
          begin
            I18n.l(value, format: :long_date)
          rescue I18n::MissingTranslationData
            value.strftime("%d/%m/%y %H:%M:%S")
          end
        when :date
          begin
            I18n.l(value, format: :short_date)
          rescue I18n::MissingTranslationData
            value.strftime("%d/%m/%Y")
          end
        when :number
          number_with_precision(value, :precision => 2, :separator => ",")
        when :enum
          presenter.model_class.const_get(field_name.upcase)[value]
        else
          value
        end
      end
    end

    def translate_field(presenter, field_name)
      field = presenter.get_field(field_name)
      field_key = field.name_for_translation
      presenter.full_model_name.classify.constantize.human_attribute_name field_key
    end

    def list_cel(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      td = "<td class='first-td'>"
      return "#{td}<span class='#{get_css_class(presenter, field, record)}'>#{result}</span></td>" if presenter.get_field(field).css_class.present?
      "#{td}#{result}</td>"
    end

    def grid_attr(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      list_attr(presenter, field, record, only_render_fields)
    end

    def list_attr(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      return "<div class='attr'><div class='label #{field}'>#{translate_field(presenter, field)}:</div><div class='field_value #{field} #{get_css_class(presenter, field, record)}'>#{result}</div></div>" if presenter.get_field(field).css_class.present?
      "<div class='attr'><div class='label #{field}'>#{translate_field(presenter, field)}:</div><div class='field_value #{field}'>#{result}</div></div>"
    end

    def get_css_class presenter, field, record
      css_class = presenter.get_field(field).css_class
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
      label = t("#{presenter.model_name.underscore}.#{action.name}", default: t("carnival.#{action.name}"))
      path = action.path(presenter, :id => record.id)
      if action.default_partial == :default
        "<a class='carnival-action-link #{label.parameterize}' href='#{path}'>#{label}</a>"
      elsif action.default_partial == :delete
        confirm = I18n.t("are_you_sure")
        "<a class='carnival-action-link apagar' data-confirm='#{confirm}' data-method='delete' href='#{path}' rel='nofollow'>#{label}</a>"
      end
    end

    def button_action_remote(action, presenter, record)
      name = action.name
      params = action.params
      label =  t("#{presenter.model_name}.#{action.name}", default: t("carnival.#{action.name}"))
      path = action.path(presenter, :id => record.id)

      success_callback = "#{name}_success_callback"
      if params[:success]
        success_callback = params[:success]
      end

      error_callback = "#{name}_error_callback"
      if params[:error]
        error_callback = params[:error]
      end

      data_overlay = ''
      if params[:show_overlay]
        data_overlay = 'data-carnival-show-overlay=true'
      end

      params[:show_overlay] = false if params[:show_overlay].nil?

      remote_function = "Carnival.remoteFunction(\"#{path}\", \"#{success_callback}\", \"#{error_callback}\", \"#{params[:method]}\", {} ,#{params[:show_overlay]})"

      "<a class='carnival-action-link editar' href='javascript:#{remote_function}'>#{label}</a>"
    end

  end
end
