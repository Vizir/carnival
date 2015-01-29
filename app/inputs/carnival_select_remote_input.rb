class CarnivalSelectRemoteInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options)
    super
    input_html_options[:class] << 'hidden-select'
    collection = []
    presenter_name = input_html_options[:data][:presenter_name]
    data_options = "data-select-presenter='#{presenter_name}' data-select-model='#{attribute_name}' "

    selected_option = @builder.object.send attribute_name.to_sym
    if selected_option.present?
      collection = [[selected_option.id, selected_option.to_label]]
      data_options << "data-select-id='#{selected_option.id}' data-select-text='#{selected_option.to_label}' "
    end

    carnival_options = input_html_options[:data][:carnival_options]
    carnival_options.each do |k, v|
      data_options << "data-select-#{k}='#{v}' " 
    end

    html = @builder.collection_select(
      "#{HashWithIndifferentAccess.new(@builder.object.class.name.constantize.reflections)[attribute_name.to_sym].foreign_key}",
      collection,
      :first, :last,
      {prompt: I18n.t("#{@builder.object.class.to_s.gsub(/^.*::/, '').downcase}.lista_#{attribute_name}.selecione", default: I18n.t("messages.select"))},
      input_html_options
    )
    "<div class='select2-remote-div' #{data_options}  ><input class='select2-remote' value='select'></input>#{html.to_s}</div>".html_safe
  end
end
