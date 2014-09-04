# -*- encoding : utf-8 -*-
module Carnival
  class AdminUserNotificationPresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show],
          :searchable => true

    field :notification,
          :actions => [:index],
          :relation_column => :title
  end
end
