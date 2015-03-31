class Todo < ActiveRecord::Base
  STATUS_ENUM = [:todo, :doing, :done]
  validates :title, presence: true

  enum status: STATUS_ENUM
end
