# action

  Define the actions of the presenter. The Carnival Gem has 4 default actions => [:show, :edit, :destroy, :new]

## Parametes:

  - target
    - [:page, :record]
    - default\_value: :record
    - Define where the action will be rendered

  - remote
    - boolean

  The parameters below are only valid for actions remotes:

  - method:
    - Method used in the Request
    - default\_value: 'GET'

  - success
    - Success Callback
    - default\_value: '[name_of_action]_success_callback'

  - error
    - Error Callback
    - default\_value: '[name_of_action]_error_callback'

## Examples:

### Custom Action

##### Presenter

Define your custom action in the presenter

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
    action :my_custom_action

  end
end
```

##### routes

  You have to define a route with the name of the action

#### Controller

  Define a action in the controller


```ruby

module Admin
  class CompaniesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def your_action
      id = params[:id]
      ...
    end

    def permitted_params
      params.permit(admin_company: [:name])
    end
  end
end

```

### Remote Action

##### Presenter

Define your custom action in the presenter

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

    action  :show

    action  :my_remote_action,
            :remote => true,
            :method => 'POST'

  end
end
```

##### routes

  You have to define a route with the name of the action

#### Controller

  Define a action in the controller


```ruby

module Admin
  class CompaniesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def remote_action
      id = params[:id]
      ...
      render :json => ...
    end

    def permitted_params
      params.permit(admin_company: [:name])
    end
  end
end

```

#### Callback Functions

  Define Javascript callback functions for your Action

> assets/companies.js

```javascript

//Following Carnival convention for callback function names

function my_remote_action_success_callback(data){
  Carnival.reloadTable();
}

function my_remote_action_error_callback(data){
  Carnival.reloadTable();
}
```
