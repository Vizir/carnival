module Carnival
  class AdminUserNotification < ActiveRecord::Base
    include ActionView::Helpers::UrlHelper
    include Carnival::ModelHelper

    belongs_to :admin_user
    belongs_to :notification

    scope :unread, -> {where('read = ?', false)}

    def message_link
      link_to(self.notification.message, Rails.application.routes.url_helpers.admin_read_admin_user_notification_path(self))
    end

    def mark_as_read_and_get_link
      self.read = true
      self.save
      self.notification.link
    end

    def to_label
      self.notification.title
    end
  end
end
