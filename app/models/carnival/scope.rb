module Carnival
  class Scope
    def initialize(name, params={})
      @params = params
      @name = name
    end

    def default?
      @params[:default].present? && @params[:default] == true
    end

    def name
      @name
    end
  end
end
