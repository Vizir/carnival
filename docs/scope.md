# scope

Create a scope in the view.

Ex:

Presenter:

```ruby

module Admin
  class CompanyPresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show], :sortable => false,
          :searchable => true,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}
    field :created_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new

    scope :all
    scope :brazilian_companies

  end
end
```

Model:

```ruby

module Admin
  class Company < ActiveRecord::Base

    include Carnival::ModelHelper
    self.table_name = "companies"

    scope :brazilian_companies, -> {includes(:country).where("countries.code = ?", "BR")}

  end
end

```
