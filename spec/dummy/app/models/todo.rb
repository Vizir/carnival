class Todo < ActiveRecord::Base
  validates :title, presence: true
end
