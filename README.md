#Carnival
By [Vizir](http://vizir.com.br/).

![Vizir Logo](http://vizir.com.br/wp-content/themes/vizir/images/logo.png)

Carnival is an easy-to-use and extensible Rails Engine to speed up the development of data management interfaces.

When you use Carnival you can benefit from made features that are already done. If you need to change anything, you can write your own version of the method, using real Ruby code without worrying about the syntax of the engine.

##Features

* Easy way to CRUD any data;
* Search data easily;
* Advanced searches in a minute. You can specify which fields you want to search for;
* Fancy time filter, based on Toggl design;
* Authentication and CRUD of users based on Devise;
* Facebook and Google authentication;
* Nice default layout, ready to use.
* User notification engine.
* New and Edit forms are easily configured. If you do ot like, you can write your own views.

##Based of the Gems we are used to
* Devise for authentication;
* OmniAuth for Facebook and Google;
* Inherited Resources on our controllers;
* SimpleForm for new and edit forms;
* WickedPDF for PDF generation;

##How it works
In some words, Carnival provides a managing infra-structure for your application. All the data related to Carnival will be located under the /admin namespace.


## Getting started

Carnival works with Rails 4.0 onwards. You can add it to your Gemfile with:

```ruby
gem 'carnival'
```

Run `bundle install`


Execute `rails generate carnival:install` after you install Carnival to copy migrations and generate the initializer.

If you already have created your database with `rake db:create`, just run `rake db:migrate` to execute the Carnival migrations.


## Basic Usage

### Model

```ruby

module Admin
  class Company < ActiveRecord::Base

    include Carnival::ModelHelper
    self.table_name = "companies"

  end
end

```

### Controller

```ruby

module Admin
  class CompaniesController < Carnival::BaseAdminController
    layout "carnival/admin"

    def permitted_params
      params.permit(admin_company: [:name])
    end
  end
end

```

### Presenter

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

  end
end
```
## Menu

The menu of the carnival can be configured in the carnival\_initializers.rb file

Ex:

``` ruby
config.menu =
{
  :city => {
    :label => "city",
    :class => "",
    :link => 'admin_cities_path', #You can use the route name as String to define the link
    :subs => [
      {
      :label => "custom_city",
      :class => "",
      :link => 'admin/custom/cities', #Or you can use the full path
      },
      {
        :label => 'google',
        :class => "",
        :link => 'http://www.google.com'
      }
    ]
  },
  ...
}

```

## Presenter Properties

### field
```ruby

  field :fiel_name, {options}

```

#### options

- :actions
  - Actions that the field will appear
  ```ruby
    :actions => [:index]
  ```

- :searchable
  - Define if the field will be searchable
  ```ruby
    :searchable => true
  ```

- :advanced_search
  - Define if the field will be in the advanced search
  ```ruby
    :advanced_search => {operator: :equal}
  ```

  - If the field is a relation, you need to define a to\_label method in the relation Model for the Carnival build the select options



### scope

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
### action

  Define the actions of the presenter. The Carnival Gem has 4 default actions => [:show, :edit, :destroy, :new]

  Parametes:

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

#### Examples:

##### Custom Action

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


#### Remote Action

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



## Specific

## Table items

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

## Configurations

### Custom AdminUser

If you want to have your own AdminUser class or need to add methods to that class, you need to do the following steps:

- Configure the ar\_admin\_user\_class in the carnival\_initializers.rb file

``` ruby
config.ar_admin_user_class = MyAdminClass
```

- Your class need to inheritance from ActiveRecord::Base

### Custom Root Action

``` ruby
config.root_action = 'my_controller#my_action'
```

### Application Name
``` ruby
config.app_name = 'Application Name'
```

##TODO
* create has many association input data
