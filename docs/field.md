# field

```ruby

  field :field_name, {options}

```

## Parameters

#### :actions
  - Actions that the field will appear

  ```ruby
    :actions => [:index]
  ```

#### :advanced\_search
  - Define if the field will be in the advanced search

  ```ruby
    :advanced_search => {operator: :equal}
  ```

#### :sortable
  - Define if the field will be sortable
  - Default Value: true

  ```ruby
    :sortable => true
  ```
  
#### :as
  - Define the type of the render that will be used to render the field. If the type passed as parameter to SimpleForm, as a type of Input. The only exception is the :partial parameter that is explained below. 
  
  ##### as: :partial
  Instead of rendereing a field, Carnival fill search for a partial with the field name. The following declaration inside AuthorsPresenter
  
```ruby
    field :custom_partial, actions: [:edit], as: :partial 
  ```
  Carnival will try to render the partial '_custom_partial.html.haml' inside /app/views/authors. 
  To be more useful the following objects are available to the called partial: 
  * record: available to all partials, it represents de current record being displayed. 
  * f: when a new or edit action is being rendered, the 'f' object will contain the current form being rendered.
  

## Relations
### Many relations
#### has\_many and has\_and\_belongs\_to\_many
For a many to many relations you should just put the field name just like any other field,
like

```ruby
field :products,
  :actions => [:show, :new, :edit]
```
###Parameters
- :show\_as\_list
  - This param list each associated record. It'll try to call a method to\_label in
    each of the associated records, if the associated record does not have a to_\label
    method the method will be the to\_s method.

    ```ruby
    field :products,
      :actions => [:show, :new, :edit],
      :show_as_list => true
    ```
- nested\_form
  - When set to true Carnival will render a nested form for the association
- nested\_form\_modes (**Required in case nested\_form is set to true**)
  - This field can have the values :new or :associate.
      - **:new** allow you edit the associated model in the same form of the current model
      - **:associate** it'll just allow you associate a related model.

###Translations
Carnival can use the default ActiveRecord model\_name to show your many relation. If you need
a different version for plural (you'll probably need one if you have a compound model name),
you can specify the same key of ActiveRecord model name appending \_plural to it, for ex:
activerecord.models.user would have a activerecord.models.user\_plural translation. If that
key exists, Carnival will use it

### One to one relations
#### belongs\_to or has\_one
For a one to one relation you have two ways to setup a field, one that is used for
exhibition and the other for edition.
#### Exhibition
If you want to show a one to one relation you should name your field with
'related\_model.related\_field\_name'.

```ruby
field 'category.name',
  :actions => [:show, :index]
```
#### Edition
If you want to edit a one to one relation you should name your field with
the name of the relation.

```ruby
field :category,
  :actions => [:new, :edit]
```


#### A sample presenter with exhibition and edition of a one to one relation
```ruby
class ProductPresenter < Carnival::BaseAdminPresenter
  field 'category.name',
    :actions => [:show, :index]

  field :category,
    :actions => [:new, :edit]
end
```
