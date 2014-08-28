
var selectRemote = function(){

  $('.select2-remote').each(function(){
    if(!$(this).closest('.nested-form-list').length)//Dont execute for nested forms selects
      addSelect2ToField(this);
  });
}

var addSelect2ToField = function(field){
  var fieldParent = $(field).parent();
  var modelName = fieldParent.data('select-model');
  var searchField = fieldParent.data('select-search_field');
  var presenterName = fieldParent.data('select-presenter');

  $(field).select2({
    placeholder: "Selecione ...",
    minimumInputLength: 2,
    width: '100%',
    ajax: buildAjaxFunction(searchField, modelName, presenterName),
    initSelection: function(element, callback) {
      var text = fieldParent.data('select-text');
      var id = fieldParent.data('select-id');
      if(!id)
        return;
      var data = {
        id: id,
        text: text
      } 
      callback(data);
    },
    dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller
    escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
  });
  $(field).on("change", function(e) { 
    var select = $(this).parent().find('select');
    select.find('option').remove().end().append('<option value='+e.added.id+'>'+e.added.text+'</option>')
  })

}

var buildAjaxFunction = function(searchField, modelName, presenterName){
  var func = { // instead of writing the function to execute the request we use Select2's convenient helper
        url: "/carnival/load_select_options",
        dataType: 'json',
        quietMillis: 1000,
        data: function (term, page) {
          return {
            q: term,
            search_field: searchField,
            model_name: modelName,
            presenter_name: presenterName
          };
        },
        results: function (data, page) {
          return {results: data};
        }
      }
    return func;
}
