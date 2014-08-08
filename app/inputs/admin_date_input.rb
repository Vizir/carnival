class AdminDateInput < SimpleForm::Inputs::Base

  include AdminBaseInput

  def input
    default_input_html_options = {class: "#{column.type}picker",
      value: @builder.object.send(attribute_name).nil? ? "" : @builder.object.send(attribute_name).strftime('%d/%m/%Y')}
    options = merge_options(default_input_html_options, input_html_options)
    return "#{@builder.text_field(attribute_name, options)}".html_safe
  end
end
