class Carnival::Avatar < ActiveRecord::Base
  include Carnival::ModelHelper

  belongs_to :imageable, polymorphic: true

  has_attached_file :photo, styles: { medium: '640x480>', thumb: '160x120>'  }, default_url: 'carnival/avatar.png'

  validates_attachment_size :photo, less_than: 1.megabytes
  validates_attachment_content_type :photo, content_type: [ 'image/jpeg', 'image/png'  ]
end
