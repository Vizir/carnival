class Todo < ActiveRecord::Base
  STATUS_ENUM = [:todo, :doing, :done]
  validates :title, presence: true
  belongs_to :todo_list

  enum status: STATUS_ENUM
end
