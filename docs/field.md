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

