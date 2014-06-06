# field

```ruby

  field :fiel_name, {options}

```

## options

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



