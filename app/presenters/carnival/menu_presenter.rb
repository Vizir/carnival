# -*- encoding : utf-8 -*-
module Carnival
  class MenuPresenter #< Carnival::MenuPresenter
    
    def initialize(current_user)
      @current_user = current_user
    end

    def before_menu (menu_label)
      true
    end  
  end
end