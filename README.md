#Carnival
By [Vizir](http://vizir.com.br/).

![Vizir Logo](http://vizir.com.br/wp-content/themes/vizir/images/logo.png)

Carnival is an easy-to-use and extensible Rails Engine to speed up the development of data management interfaces.

When you use Carnival you'll benefit from a big suite of feature already done. If you need to change anything, you can write your own version of the code, using real Ruby code in Rails standard components without worrying about a specific syntax or DSL.

##Features

* Easy way to CRUD any data;
* Search data easily;
* Advanced searches in a minute. You can specify which fields you want to search for;
* Fancy time filter, based on Toggl design;
* Nice default layout, ready to use.
* New and Edit forms are easily configured. If you do ot like, you can write your own views.

### Detailed features list
* Index List
  - Ordering by any column
  - Scope
  - Advanced Search
  - Custom Links
  - Remote Actions
  - Custom Actions
  - Batch Operations
  - Custom Css Cel
  - Delete 
  - CSV Export
  - PDF Export
* Edit form
  - Create new
  - Update existent
  - Nested Form
  - Associate an existent
  - Create new
  - Update
  - Delete
  - ImagePreview
  - Relation select (Autocomplete)
  - Grid config (field order and size)
  - Select Enum
* Show
  - Grid config (field order and size)
  - Relation links
  - Custom partial view
  - Show as list
* Menu
  - Customize Order, route, text, label and class


## It can be easily integrated with gems that you are already used to use
### Authentication
* [Devise](docs/integrations/devise.md)

### Rich Text Editor
* [CKEditor](docs/integrations/ckeditor.md)

### Upload files
* [Paperclip](docs/integrations/paperclip.md)


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


## What does Carnival include?

After you install Carnival, you will have a running CRUD application which is ready to manage the currently register useres. The real power of Carnival is that you easily extend to manage your data. Let's start to use it.

### Carnival Admin Application

The Carnival application will be under the '/admin' namespace.
Some features are already implemented. To use it, do the following:

* Start your Rails web server and acess the `/admin` page.

`http://server-name/admin`

## Basic Usage

Carnival started relying only on MVC model. As we developed it, we saw that it would be good to have a Presenter to better describe our models. We used the presenter to avoid the fat models emerge on our systems.

### Model

It is a commom Active Record model.
We only have to include the Carnival Helper.

`include Carnival::ModelHelper`

```ruby

module Admin
  class Company < ActiveRecord::Base

    include Carnival::ModelHelper
    self.table_name = "companies"

  end
end

```

### Controller

It is also a commom Controller, with some things to note:
* Inherits from `Carnival::BaseAdminController`
* Uses the default admin layout: `layout "carnival/admin"`
* When creating or editing data, you should configure the Rails 4 permitted params.

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

All the "magic" of Carnival happens at Presenter. Each model managed under Carnival Admin will have a presenter associated to it. The presenter describes each model attributed that will be acessible in any of Carnival's CRUD interfaces.

```ruby

module Admin
  class CompanyPresenter < Carnival::BaseAdminPresenter
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

  end
end
```

### Dependent Selects

This feature is used when you have dependent selects like Country, State and City to fill an Address or a Location, because Cities Select only can be filled withe the oprions when a State is selected, and the State when de Country is selected, to implement this kind of behavior in a form, just use the option :depends_on in the dependent field with the symbol of the dependency, follows an example bellow:

```ruby
field :country,
      :actions => [:index, :csv, :pdf, :new, :edit, :show]
field :state,
      :actions => [:index, :csv, :pdf, :new, :edit, :show]
      :depends_on => :country
field :city,
      :actions => [:index, :csv, :pdf, :new, :edit, :show]
      :depends_on => :state
```


## Menu

The menu of the carnival can be configured in the 'config\initializers\carnival_initializers.rb' file

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

## [Presenter Properties](docs/presenter.md)


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

### Custom Views

The Carnival permits that you specify some partials for your page, you just need just add your partial in the app/views/carnival/extra\_header.html.haml

Possible Partials:

- extra\_header
  - Extra html to render in page header

- app\_logo
  - Define a specific partial for your app logo
  - Default Value: link\_to App Name, root\_path

- extra\_footer
  - Extra html to render in page footer


## Configurations

### Custom AdminUser

If you want to have your own AdminUser class or need to add methods to that class, you need to do the following steps:

- Configure the ar\_admin\_user\_class in the carnival\_initializers.rb file

``` ruby
config.devise_class_name = 'MyAdminClass'
```

- Your class need to inheritance from Carnival::AdminUser

### Custom Root Action

``` ruby
config.root_action = 'my_controller#my_action'
```

### Application Name
``` ruby
config.app_name = 'Application Name'
```

## Custom Translations

You can add custom translations for the actions [:new, :show, :edit, :destroy]

```ruby
  company:
    new: Create New company
    show: Show company
```

## Additional Docs
You can find more detailed docs in the links below

- [Action](docs/action.md)
- [Field](docs/field.md)
- [Presenter](docs/presenter.md)
- [Scope](docs/scope.md)


##TODO
* create has many association input data