# Controller properties

## Specific

### Table items

If you want to determine a specific list of items that will appear in the table you have to define the table\_items method in your controller returning a Array or ActiveRelation

Ex:

```ruby

module Admin
  class CompaniesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def table_items
      Company.where(:country => 'Brazil')
    end

    def permitted_params
      params.permit(admin_company: [:name])
    end
  end
end

```

### Presenter Class Name

If you want to define a custom Presenter you need to define in your controller the method carnival\_presenter\_class

Ex:

```ruby

  class CompaniesController
    def carnival_presenter_class
      MyCustomCompanyPresenter
    end
  end

```

In this case you have to define the method full\_model\_name  in your presenter

Ex:

```ruby

  class MyCustomCompanyPresenter
    field :id,
          :actions => [:index, :show], :sortable => false,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :edit, :show],
          :advanced_search => {:operator => :like}
    field :created_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new

    def full_model_name
      'Company'
    end

  end

```