class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data, :styles => { :content => '800>' }

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 2.megabytes
  validates_attachment_content_type :data, :content_type => /\Aimage/

  def url_content
    url(:content)
  end
end
