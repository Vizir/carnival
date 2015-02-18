#Carnival
By [Vizir](http://vizir.com.br/).

![Vizir Logo](http://vizir.com.br/wp-content/themes/vizir/images/logo.png)

Carnival is an easy-to-use and extensible Rails Engine to speed up the development of data management interfaces..

When you use Carnival you'll benefit from a set of features already done. If you need to change anything, you can write your own version of the code, using real Ruby code in Rails standard components without worrying about a specific syntax or DSL.

##Features

* Easy way to CRUD any data;
* Search data easily. Advanced searches in a minute. You can specify which fields you want to search for;
* Fancy time filter, based on Toggl design;
* Nice default layout, ready to use.
* New and Edit forms are easily configured. If you do not like, you can write your own views.



##How it works
It provides a managing infra-structure for your application.


## Getting started

Carnival works with Rails 4.0 onwards. You can add it to your Gemfile with:

```ruby
gem 'carnival'
```

Run `bundle install`


Execute `rails generate carnival:install` after you install Carnival to generate the initializer.



## Basic Usage

Carnival started relying only on MVC model. As we developed it, we realized that a Presenter would better describe our models. We used the presenter to avoid fat models to emerge on our design.

### Model

It is a commom Active Record model.
We only have to include the Carnival Helper.

`include Carnival::ModelHelper`

```ruby

module Admin
  class Company < ActiveRecord::Base

    include Carnival::ModelHelper

  end
end

```

### Controller

It is also a commom Controller, with some minor differences:
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

All the "magic" of Carnival happens at Presenter. Each model managed under Carnival Admin will have a presenter associated to it. The presenter describes how the model's attributes will be presented. 

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

See more about the Presenter at [Presenter Properties](docs/presenter.md).

### Menu

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

##Customizing Carnival

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


### Configurations

#### Custom AdminUser

If you want to have your own AdminUser class or need to add methods to that class, you need to do the following steps:

- Configure the ar\_admin\_user\_class in the carnival\_initializers.rb file

``` ruby
config.devise_class_name = 'MyAdminClass'
```

- Your class need to inheritance from Carnival::AdminUser

#### Custom Root Action

``` ruby
config.root_action = 'my_controller#my_action'
```

#### Application Name
``` ruby
config.app_name = 'Application Name'
```

### Internationalization

You can add custom translations for the actions [:new, :show, :edit, :destroy]

```ruby
  company:
    new: Create New company
    show: Show company
```



### Integrations###
It can be easily integrated with gems that you are already used to use
#### Authentication
* [Devise](docs/integrations/devise.md)

#### Rich Text Editor
* [CKEditor](docs/integrations/ckeditor.md)

#### Upload files
* [Paperclip](docs/integrations/paperclip.md)


## Detailed features list
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

## Additional Docs
You can find more detailed docs in the links below

- [Action](docs/action.md)
- [Controller](docs/controller.md)
- [Field](docs/field.md)
- [Presenter](docs/presenter.md)
- [Scope](docs/scope.md)


