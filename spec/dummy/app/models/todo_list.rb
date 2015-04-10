class TodoList < ActiveRecord::Base
  include Carnival::ModelHelper
  has_many :todos
end
