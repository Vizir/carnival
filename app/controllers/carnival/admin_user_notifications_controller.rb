# -*- encoding : utf-8 -*-
module Carnival
  class AdminUserNotificationsController < Carnival::BaseAdminController
    layout "carnival/admin"

    def read
      admin_user_notification = AdminUserNotification.find params[:id]
      link = admin_user_notification.mark_as_read_and_get_link
      redirect_to link
    end

    def generate_datatable
      query = Carnival::AdminUserNotification.where('admin_user_id =  ? ', current_admin_user.id)
      modelo_presenter = Carnival::AdminUserNotificationPresenter.new(query)
      @admin_user_notifications = []
      GenericDatatable.new(view_context, AdminUserNotification, self, modelo_presenter, query)
    end
  end
end
