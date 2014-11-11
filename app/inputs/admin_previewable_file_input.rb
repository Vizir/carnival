class AdminPreviewableFileInput < SimpleForm::Inputs::FileInput
  def input(wrapper_options)
    template.image_tag(object.send(attribute_name).url(:thumb), class: 'previewable') + super
  end

  def input_html_classes
    super.push('previewable')
  end
end
