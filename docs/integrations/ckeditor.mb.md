
## Install and Configure CKEditor
Install and configure following the [CKEditor installation instructions](https://github.com/galetahub/ckeditor#installation)

## Load CKEditor Scripts

Add the ckeditor/init in the custom javascript load config in the Carnival Initializer.

Edit `config/initializers/carnival_initializer.rb` and add `ckeditor/init` to load.

Ex.

```ruby

  config.custom_javascript_files = ["ckeditor/init"]
```

## Set field to use CKEditor in the presenter

```ruby

  field :bio,
    actions: [:index, :new, :edit, :show, :csv],
    as: :ckeditor,
    input_html: { ckeditor: {toolbar: 'Full'} }

```
