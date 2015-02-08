# Presenter Properties

- [field](field.md)
- [scope](scope.md)
- [action](action.md)

## Defining if a field or action will be shown

The presenter implements some conditional methods to verify if a action or field must be displayed. 
If some additional information is needed, the following objects will be available on these render methods: 
* current_user: the 'current_user' variable inside the controller context.  
* @controller: the current controller of the application. 

### render_field? (field_name,action_name)
Before rendering a field, Carnival calls the '''.render_field?''' method on presenter. If this method returns a false value, the field wil not be displayed. 

* field_name: name of the field that will be rendered. 
* action_name: name of the controller action that is being executed ("index", "edit", "new" ...) 

```ruby
  def render_field?(field, action)
    return false if action == "show" and field.name == :surname
    true
  end
```
### render_action? (record_action, action_name)
Before rendering an action, Carnival calls the '''.render_action?'''method on presenter. If this method returns a false value, the field wil not be displayed.   

* record_action: name of the action that will be rendered. 
* action_name: name of the controller action that is being executed ("index", "edit", "new" ...) 

```ruby
  def render_action?(record_action, action)
    return false if record_action == :edit
    true
  end
```


## Dependent Selects

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
