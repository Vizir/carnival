class AdminCurrencyInput < SimpleForm::Inputs::Base

  include ActionView::Helpers::NumberHelper
  include AdminBaseInput

  def input
    default_input_html_options = {class: 'money',
      value: number_with_precision(@builder.object.send(attribute_name), separator: ",", precision: 2) }
    options = merge_options(default_input_html_options, input_html_options)
    return "#{@builder.text_field(attribute_name, options)}".html_safe
  end
end