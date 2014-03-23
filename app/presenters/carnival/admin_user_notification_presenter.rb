# -*- encoding : utf-8 -*-
module Carnival
  class AdminUserNotificationPresenter < Carnival::BaseAdminPresenter
    def listagem(tipo = nil)
      [:notification__title, :message_link, :created_at]
    end

    def _listagem_botoes_extras
      [
        {
          :link => 'admin_mark_notification_as_read',
          :nome => "#{I18n.t('notification.mark_as_read')}",
          :remote => true,
          :success => 'markAsReadCallback',
          :error => 'errorCallback',
          :method => 'POST',
          :campo => :mark_as_read_button
        }
      ]
    end

    def remoto?
      true
    end

    def listagem_botoes
      {:novo => false, :editar=> false, :apagar => false}
    end

    def busca_remoto?
      true
    end

    def ordenacao_remoto
      [:id]
    end

    def escopo
      [:all, :unread]
    end

    def filtro_data
      nil
    end

    def escopo_padrao
      :unread
    end

    def busca_remoto
      [:title, :message]
    end

    def advanced_search
      {
        :notification__title => [:field, :like],
        :notification__message => [:field, :like]
      }
    end
  end
end
