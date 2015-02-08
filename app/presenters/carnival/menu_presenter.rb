# -*- encoding : utf-8 -*-
module Carnival
  class MenuPresenter #< Carnival::MenuPresenter
    
    def initialize(controller)
      @controller = controller
    end

    def before_menu (menu_label)
      true
    end  
  end
end