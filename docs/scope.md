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

### Custom visibility

Your scopes can have custom visibility, for example if you want show it only for an admin_user,
for that you must specify a hide_if, options when defining the scope. This must be a proc or a
lambda, if it returns true the scope will not be shown.
This is executed in the controller binding, so you have access to everything the current controller has
Following is an example of how to define a custom scope visibility:
``` ruby
scope :all, hide_if: proc { !current_user.admin?  }
scope :subset, hide_if: -> { !current_user.has_role('role')?  }
```
