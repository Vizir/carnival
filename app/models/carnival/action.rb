module Carnival
  class Action
    include Rails.application.routes.url_helpers
    PARTIAL_DEFAULT = :default
    PARTIAL_DELETE = :delete
    PARTIAL_REMOTE = :remote

    def initialize(name, params={})
      @name = name
      @params = params
      @partial = default_partial
      @path = params[:path] if params[:path].present?
      @controller = params[:controller]
      @route_name = params[:route_name]
    end

    def path(presenter, extra_params={})
      if @path.nil?
        params = {controller: @controller || presenter.controller_name, action: @name}
      elsif !@path[:controller].nil?
        params = @path
      else
        params = {path: @path}
      end
      params = params.merge(extra_params) if extra_params.present?
      params = params.merge(:only_path => true)
      if @route_name
        Rails.application.routes.url_helpers.send(@route_name, params)
      else
        url_for(params)
      end
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
