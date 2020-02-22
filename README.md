# Carnival

[![Join the chat at https://gitter.im/Vizir/carnival](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Vizir/carnival?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

By
[![Vizir Logo](http://vizirsite.wpengine.com/wp-content/uploads/2016/06/logo_software_studio.png)](http://vizir.com.br/)

Carnival is an easy-to-use and extensible Rails Engine to speed up the development of data management interfaces.
It provides a managing infra-structure for your application.

When you use Carnival you'll benefit from a set of features out-of-the-box. If you need to change anything, you can write your own version of the code, using real Ruby code in Rails standard components without worrying about a specific syntax or DSL.

## Requirements
* Carnival works with Rails 4.0 onwards.

## Features
* Easy way to CRUD any data;
* Search data easily. Advanced searches in a minute. You can specify which fields you want to search for;
* Fancy time filter, based on Toggl design;
* Nice default layout, ready to use;
* New and Edit forms are easily configured. If you do not like them, you can write your own views.

## Detailed features

* Index List
  - Ordering by any column
  - Scope
  - Advanced Search
  - Custom Links
  - Remote Actions
  - Custom Actions
  - Batch Operations
  - Custom CSS Cell
  - Delete
  - CSV Export

* Edit form
  - Create new
  - Update existent
  - Nested Form
  - Associate an existent
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

You can find more detailed docs in the links below:

- [Action](docs/action.md)
- [Controller](docs/controller.md)
- [Field](docs/field.md)
- [Presenter](docs/presenter.md)
- [Scope](docs/scope.md)


## Getting started

Add the gem to your Gemfile:

```ruby
gem 'carnival'
```

Run `bundle install`.

Then, execute `rails generate carnival:install` to generate the initializer.

### Basic Usage

Carnival started relying only on MVC model. As we developed it, we realized that a Presenter would better describe our models. We used the presenter to avoid fat models to emerge on our design.

### Model

It is a regular Active Record model. We only have to include the Carnival Helper:

```ruby
module Admin
  class Company < ActiveRecord::Base
    include Carnival::ModelHelper
  end
end
```

### Controller

It is also a regular Controller, with some minor differences:

* Inherits from `Carnival::BaseAdminController`
* Uses the default admin layout: `layout 'carnival/admin'`
* When creating or editing data, you should configure the permitted params.

```ruby
module Admin
  class CompaniesController < Carnival::BaseAdminController
    layout 'carnival/admin'

    # ...

    private

    def permitted_params
      params.permit(admin_company: [:name])
    end
  end
end
```

See more about the Controller at [Controller Properties](docs/controller.md)

### Presenter

All the "magic" of Carnival happens at Presenter. Each model managed under Carnival Admin will have a presenter associated to it. The presenter describes how the model's attributes will be presented.

```ruby
module Admin
  class CompanyPresenter < Carnival::BaseAdminPresenter
    field :id,
          actions: [:index, :show], sortable: false,
          advanced_search: { operator: :equal }
    field :name,
          actions: [:index, :new, :edit, :show],
          advanced_search: { operator: :like }
    field :created_at, actions: [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new
  end
end
```

See more about the Presenter at [Presenter Properties](docs/presenter.md).

### Menu

The menu of Carnival can be configured in the 'config/initializers/carnival_initializers.rb' file.

Eg.:

``` ruby
config.menu = {
  city: {
    label: 'city',
    class: '',
    link: 'admin_cities_path', # You can use the route name as String to define the link
    subs: [
      {
        label: 'custom_city',
        class: '',
        link: 'admin/custom/cities', # You can also use the full path
      },
      {
        label: 'google',
        class: '',
        link: 'http://www.google.com'
      }
    ]
  },

  # ...
}
```

## Customizing Carnival

### Custom Views

Carnival permits that you specify some partials for your page, you just need to add your partial in the `app/views/carnival/extra_header.html.haml`.

Possible Partials:

- `extra_header`
  - Extra HTML to render in page header.

- `app_logo`
  - Define a specific partial for your app logo.
  - Default Value: `link_to <App Name>, root_path`

- `extra_footer`
  - Extra HTML to render in page footer.

### Configurations

#### Custom AdminUser

If you want to have your own AdminUser class or need to add methods to that class, you need to do the following steps:

- Configure the `ar_admin_user_class` in the `carnival/_initializers.rb` file.

``` ruby
  config.devise_class_name = 'MyAdminClass'
```

- Your class need to inherit from `Carnival::AdminUser`.

#### Custom Root Action

``` ruby
  config.root_action = 'my_controller#my_action'
```

#### Application Name

``` ruby
  config.app_name = 'Application Name'
```

### I18n

You can add custom translations for the actions [:new, :show, :edit, :destroy]

```ruby
  company:
    new: Create New company
    show: Show company
```

### Integrations

It can be easily integrated with gems that you already know and use.

#### Authentication

* [Devise](docs/integrations/devise.md)

#### Rich Text Editor

* [CKEditor](docs/integrations/ckeditor.mb.md)

#### File upload

* [Paperclip](docs/integrations/paperclip.md)