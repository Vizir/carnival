# -*- encoding : utf-8 -*-
module Carnival
  class NotificationsController < Carnival::BaseAdminController
    layout "carnival/admin"

    def table_list
      query = Carnival::Notification.joins(:admin_user).where('admin_user_id =  ? ', current_admin_user.id)
      query
    end
  end
end
