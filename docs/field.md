# field

```ruby

  field :field_name, {options}

```

## Parameters

- :actions
  - Actions that the field will appear
  ```ruby
    :actions => [:index]
  ```

- :searchable
  - Define if the field will be searchable
  - Default Value: false
  ```ruby
    :searchable => true
  ```

- :advanced_search
  - Define if the field will be in the advanced search
  ```ruby
    :advanced_search => {operator: :equal}
  ```

  - If the field is a relation, you need to define a to\_label method in the relation Model for the Carnival build the select options


- :sortable
  - Define if the field will be sortable
  - Default Value: true
  ```ruby
    :sortable => true
  ```

- :show_view
  - Define a custom partial view that can be used to override the rendering of a specific field
  - Default Value: nil
  ```ruby
    :show_view => 'field_name' #in this case it will search for a partial named _field_name
  ```

## Required Parameters for related fields
You can have a field that is a relation, for example the field category
in product, in this case you must supply the **relation_column** attribute,
which will be used to show the value of your field and to sort the results
in the grid.
``` ruby
    :relation_column => :name # this is the name of the field in the related
                              # entity
```
Another way you can show a related field is putting the related field name in
the field declaration, and adding the **owner_relation** parameter to that
field.
Suppose that you have a model Product that **belongs_to** a Category, and
you wanna show the category_name field in the Category model, you may
put a field category_name in the ProductPresenter and add the attribute
**owner_relation** to the field declaration, so Carnival will look
directly on category when search for that attribute. Following is a simple
example:
``` ruby
class ProductPresenter < Carnival::BaseAdminPresenter
  field :category_name, # the product model does not need to have this field
    :actions => [:index, :show, :edit],
    :owner_relation => :category
end
```
