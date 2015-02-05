# Presenter Properties

- [field](field.md)
- [scope](scope.md)
- [action](action.md)

## Defining if a field or action will be shown

### render_field? (field_name,action_name)
Before rendering a field, Carnival calls the '''.render_field?''' method on presenter. If this method returns a false value, the field wil not be displayed. 

* field_name: name of the field that will be rendered. 
* action_name: name of the controller action that is being executed ("index", "edit", "new" ...) 

### render_action? (record_action, action_name)
Before rendering an action, Carnival calls the '''.render_action?'''method on presenter. If this method returns a false value, the field wil not be displayed.   

* record_action: name of the action that will be rendered. 
* action_name: name of the controller action that is being executed ("index", "edit", "new" ...) 

