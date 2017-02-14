# action

  Define the actions of the presenter. The Carnival gem has 4 default actions => [:show, :edit, :destroy, :new]

## Parameters

  - target
    - [:page, :record]
    - default\_value: :record
    - Define where the action will be rendered

  - show_func
    - Define the function to be used to decide if the action wil be rendered or not

  - remote
    - boolean

### Parameters for remote actions

The following are valid only for remote actions:

  - method
    - Method used in the Request
    - default\_value: 'GET'

  - success
    - Success Callback
    - default\_value: '[name_of_action]_success_callback'

  - error
    - Error Callback
    - default\_value: '[name_of_action]_error_callback'


#### :hide_if

  - Your actions can have custom visibility, if you want for instance to show them only to an admin_user. To do that you must specify a `hide_if` option when defining the action. This must be a proc or a lambda and if it returns `true` the scope will not be shown.

  - The `hide_if` proc/lambda is executed in the controller action, so you have access to all of the controller variables and the @record variable is injected in the action, so you can make conditions using the record data.

Example:
  ``` ruby
    action  :remove_from_blacklist,
            :remote => true,
            :method => 'POST',
            :hide_if => proc { @record.blacklisted && @current_admin_user.current_account_id == @record.account_id }
  ```

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
