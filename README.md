# Carnival

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