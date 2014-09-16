
## Install and Configure Paperclip
Install and configure following the [Paperclip installation instructions](https://github.com/thoughtbot/paperclip#installation)

## Configure migration to use Paperclip
Configure the migration to use Paperclip for a specific field, in the example bellow Paperclip will be used to upload a file to `image` attribute.


```ruby

  create_table :photos do |t|
    t.attachment :image
    t.string :title
    t.references :person, index: true
    t.timestamps
  end
```


## Configure model to use Paperclip
Configure the model to use Paperclip for a specific field, in the example bellow Paperclip will be used to upload a file to `image` attribute.


```ruby

class Photo < ActiveRecord::Base

  has_attached_file :image, styles: { medium: '640x480>', thumb: '160x120>'  }, default_url: 'missing.png'

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

end

```

## Configure Presenter to use admin_previewable_input
In your presenter use the admin_previewable_file input to handle the field configures with paperclip.

```ruby

  field :image,
    actions: [:new, :edit, :show],
    as: :admin_previewable_file
```

Example of the rendered edit form:

![Upload With paperclip](https://dl.dropboxusercontent.com/u/2134454/cdn/carnival/carnival-paperclip-upload.png)

## Full functional Sample Application

### Sourcecode
* [Carnivel Sample Application on Github](https://github.com/Vizir/carnival-sample-application)
* Sample Presenter source code using the Paperclip Integration - [Photo Presenter](https://github.com/Vizir/carnival-sample-application/blob/master/app/presenters/photo_presenter.rb)

### Online Sample
* Home application [carnival.vzr.com.br](http://carnival.vzr.com.br)
* CRUD using Paperclip [carnival.vzr.com.br/people](http://carnival.vzr.com.br/people)

