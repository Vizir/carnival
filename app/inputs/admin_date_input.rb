class AdminDateInput < SimpleForm::Inputs::Base

  include AdminBaseInput

  def input(wrapper_options)
    format = if column.type == :datetime then '%Y/%m/%d %H:%M' else '%Y/%m/%d' end
    default_input_html_options = {class: "#{column.type}picker",
      value: @builder.object.send(attribute_name).nil? ? "" : @builder.object.send(attribute_name).strftime(format)}
    options = merge_options(default_input_html_options, input_html_options)
    return "#{@builder.text_field(attribute_name, options)}".html_safe
  end
end
