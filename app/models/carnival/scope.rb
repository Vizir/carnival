module Carnival
  class Scope
    def initialize(name, params={})
      @params = params
      @name = name
    end

    def default?
      @params[:default]
    end

    def name
      @name
    end

    def hidden?(controller)
      if @params.has_key?(:hide_if)
        block = @params[:hide_if]
        controller.instance_eval(&block)
      else
        false
      end
    end
  end
end
