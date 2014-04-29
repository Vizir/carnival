module Carnival
  class Notification < ActiveRecord::Base
    include Carnival::ModelHelper
    has_many :admin_user_notifications

    def to_label
      self.title
    end
  end
end
