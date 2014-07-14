class AdminEnumInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    super
    @builder.collection_select(
      attribute_name, @builder.object.class.const_get(attribute_name.to_s.upcase),
      :first,
      :last,
      prompt: I18n.t("#{@builder.object.class.to_s.gsub(/^.*::/, '').downcase}.list_#{attribute_name}.select",
                default: I18n.t("messages.select")),
      input_html: {:class=> 'chosen'}
    )
  end
end

