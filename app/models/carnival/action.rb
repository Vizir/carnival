module Carnival
  class Action
    include Rails.application.routes.url_helpers
    PARTIAL_DEFAULT = :default
    PARTIAL_DELETE = :delete
    PARTIAL_REMOTE = :remote

    def initialize(presenter, name, params={})
      @presenter = presenter
      @name = name
      @params = params
      @partial = default_partial
      @path = params[:path] if params[:path].present?
    end

    def path(extra_params={})
      if @path.nil?
        params = {controller: @presenter.controller_name, action: @name}
      else
        params = {path: @path}
      end
      params = params.merge(extra_params) if extra_params.present?
      params = params.merge(:only_path => true)
      url_for(params)
    end

    def show(record)
      return true if !params[:show_func]
      return true if !record.respond_to? params[:show_func]
      record.send params[:show_func]
    end

    def partial
      @partial
    end

    def params
      @params
    end

    def name
      @name
    end

    def remote?
      @params[:remote]
    end


    def target
      return :record if @params[:target].nil?
      @params[:target]
    end

    def default_partial()
      if [:new, :edit, :show].include?(@name)
        PARTIAL_DEFAULT
      elsif @name == :destroy
        PARTIAL_DELETE
      elsif remote?
        PARTIAL_REMOTE
      else
        PARTIAL_DEFAULT
      end
    end
  end
end
