module Carnival
  class Notification < ActiveRecord::Base
    has_many :admin_user_notifications
  end
end
