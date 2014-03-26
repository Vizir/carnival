# -*- encoding : utf-8 -*-
module Carnival
  class AdminUserPresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show],
          :sortable => {:direction => :asc, :default => true},
          :searchable => true,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :show, :edit],
          :searchable => true,
          :advanced_search => {:operator => :like},
          position: {line: 1, column: 1}
    field :email,
          :actions => [:index, :new, :show, :edit],
          :sortable => true,
          :searchable => true,
          :advanced_search => {:operator => :like},
          position: {line: 1, column: 2, size: 5}
    field :last_sign_in_at, :actions => [:index, :show]
    field :sign_in_count, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new
    # action :teste1, :target => :record, :path=>"http://www.google.com.br"
    # action :teste2, :target => :page, :path=>"http://www.google.com.br"
end
