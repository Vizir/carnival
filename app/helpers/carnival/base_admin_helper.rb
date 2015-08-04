module Carnival
  module BaseAdminHelper
    def set_resource_actived_if_current(path)
      (request.fullpath == path) ? 'actived' : ''
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

    def caminho_modelo(action, extra_params = nil)
      params = { controller: controller.controller_name, action: action }
      params = params.merge(extra_params) if extra_params.present?
      url_for(params)
    end

    def carnival_render_if_exist(partial_path)
      render partial_path if partial_exist?(partial_path)
    end

    def partial_exist?(partial_path)
      File.exist?(get_partial_path(partial_path))
    end

    def has_many_relation?(model, field)
      klass = Carnival::KlassService.new model.class
      klass.is_a_has_many_relation?(field.to_sym)
    end

    def has_one_relation?(model, field)
      klass = Carnival::KlassService.new model.class
      klass.is_a_has_one_relation?(field.to_sym)
    end

    def many_to_many_relation?(model, field)
      klass = Carnival::KlassService.new model.class
      klass.is_a_many_to_many_relation?(field.to_sym)
    end

    def get_partial_path(partial_path)
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

    def menu_link(link)
      link.strip!
      if link.to_s.end_with?('_path') || link.to_s.end_with?('_url')
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

    def field_to_show(presenter, field_name, record, show_only_values=false)
      if presenter.fields[field_name].params[:as] == :partial
        raw(render presenter.fields[field_name].partial_name, record: record)
      else
        rendered = field_value_and_type presenter, field_name, record
        field_type = rendered[:field_type]
        value = rendered[:value]

        is_relation = presenter.relation_field?(field_name)

        if value.present?
          formatted_field = format_field(presenter, field_name, field_type, value)
          if is_relation && !show_only_values
            link_to(formatted_field, presenter.relation_path(field_name, record))
          else
            formatted_field
          end
        end
      end
    end

    def field_value_and_type(presenter, field_name, record)
      renderer = FieldRenderers::RendererCreator
                 .create_field_renderer(presenter, field_name)

      renderer.render_field(record)
    end

    def is_image?(field_type, value)
      field_type.nil? and value.class.to_s == "Paperclip::Attachment" and value.content_type.include? "image"
    end

    def format_field(presenter, field_name, field_type, value)
      if is_image?(field_type, value)
        image_tag value.url(:thumb), alt: translate_field(presenter, field_name), class: 'attr'
      else
        case field_type
        when :datetime
          begin
            I18n.l(value, format: :long_date)
          rescue I18n::MissingTranslationData
            value.strftime('%d/%m/%y %H:%M:%S')
          end
        when :date
          begin
            I18n.l(value, format: :short_date)
          rescue I18n::MissingTranslationData
            value.strftime('%d/%m/%Y')
          end
        when :number
          number_with_precision(value, precision: 2, separator: ',')
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
      presenter.model_class.human_attribute_name field_key
    end

    def list_cel(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      td = "<td class='first-td'>"
      return "#{td}<span class='#{get_css_class(presenter, field, record)}'>#{result}</span></td>" if presenter.get_field(field).css_class.present?
      "#{td}#{result}</td>"
    end

    def empty_cel(presenter, field, record, only_render_fields)
      return "<td class='first-td'><span class='#{get_css_class(presenter, field, record)}'></span></td>" if presenter.get_field(field).css_class.present?
      "<td class='first-td'></td>"
    end

    def grid_attr(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      list_attr(presenter, field, record, only_render_fields)
    end

    def hide_column?(field, records, controller)
      hide = true
      records.each do |record|
        unless field.hidden?(record, controller)
          hide = false
        end
      end
      hide
    end

    def list_attr(presenter, field, record, only_render_fields)
      result = field_to_show(presenter, field, record, only_render_fields)
      return result if only_render_fields
      return "<div class='attr'><div class='label #{field}'>#{translate_field(presenter, field)}:</div><div class='field_value #{field} #{get_css_class(presenter, field, record)}'>#{result}</div></div>" if presenter.get_field(field).css_class.present?
      "<div class='attr'><div class='label #{field}'>#{translate_field(presenter, field)}:</div><div class='field_value #{field}'>#{result}</div></div>"
    end

    def get_css_class(presenter, field, record)
      css_class = presenter.get_field(field).css_class
      if css_class.is_a? Hash
        record.send(css_class[:method])
      else css_class
        css_class.presence || ''
      end
    end

    def list_buttons(presenter, record)
      if presenter.actions_for_record.any?
        presenter.actions_for_record.map do |_, record_action|
          next unless presenter.render_action?(record, record_action, params[:action])
          next if record_action.hidden?(record, controller)
          if record_action.remote?
            button_action_remote(record_action, presenter, record)
          else
            button_action(record_action, presenter, record)
          end
        end.reject(&:nil?).inject(:+)
      else
        ""
      end
    end

    def button_action(action, presenter, record)
      label = t("#{presenter.model_name.underscore}.#{action.name}", default: t("carnival.#{action.name}"))
      path = action.path(presenter, id: record.id)

      if action.default_partial == :default
        link_to label, path, class: "carnival-action-link #{label.parameterize}"
      elsif action.default_partial == :delete
        link_to label, path, class: 'carnival-action-link apagar', method: :delete, data: { confirm: I18n.t('are_you_sure') }
      end
    end

    def button_action_remote(action, presenter, record)
      params = action.params
      label =  t("#{presenter.model_name}.#{action.name}", default: t("carnival.#{action.name}"))
      path = action.path(presenter, id: record.id)

      success_callback = params[:success] || "#{action.name}_success_callback"
      error_callback = params[:error] || "#{action.name}_error_callback"
      params[:show_overlay] = params[:show_overlay].presence || false

      remote_function = "Carnival.remoteFunction('#{path}', '#{success_callback}', '#{error_callback}', '#{params[:method]}', {} , #{params[:show_overlay]})"

      link_to label, "javascript: #{remote_function}", class: 'carnival-action-link editar'
    end
  end
end
