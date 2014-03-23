class AdminTextInput < SimpleForm::Inputs::TextInput
  def input_html_options
    @input_html_options[:rows] = 5
    @input_html_options[:cols] = 75
    super
  end
end
