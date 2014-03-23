module AdminBaseInput
  def merge_options(default_input_html_options, input_html_options)
    input_html_options[:class].push(default_input_html_options[:class])
    input_html_options[:class] = input_html_options[:class].uniq
    input_html_options[:value] = default_input_html_options[:value]
    return input_html_options
  end
end