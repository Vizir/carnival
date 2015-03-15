class Post < ActiveRecord::Base
  validates :title, :content, presence: true
end
