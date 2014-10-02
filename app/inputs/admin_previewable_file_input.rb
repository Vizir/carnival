class AdminPreviewableFileInput < SimpleForm::Inputs::FileInput
  def input
    template.image_tag(object.send(attribute_name).url(:thumb), class: 'previewable') + super
  end
  
  def input_html_classes
    super.push('previewable')
  end

  def show(record, field, presenter)
    result = field_to_show(presenter, field, record, false)
    "<img class='attr' src='#{result}' alt='#{translate_field(presenter, field)}' />"
  end
end
