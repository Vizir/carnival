class AdminPreviewableFileInput < SimpleForm::Inputs::FileInput
  def input
    super + template.image_tag(object.send(attribute_name).url(:thumb), class: 'previewable')
    end
  def input_html_classes
    super.push('previewable')
  end
end
