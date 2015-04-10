class AdminDateInput < SimpleForm::Inputs::Base

  include AdminBaseInput

  def input(wrapper_options)
    f = I18n.t('date.formats.default')
    format = if column.type == :datetime then "#{f} %H:%M" else "#{f}" end
    default_input_html_options = {class: "#{column.type}picker",
      value: @builder.object.send(attribute_name).nil? ? "" : @builder.object.send(attribute_name).strftime(format)}
    options = merge_options(default_input_html_options, input_html_options)
    return "#{@builder.text_field(attribute_name, options)}".html_safe
  end
end
