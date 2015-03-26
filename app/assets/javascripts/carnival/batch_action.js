Carnival.batchActionFunction = function(){
  var value = $(this).val();
  if($(this).is(':checked')){
    $(this).parent().parent().addClass('batch_action_item_selected');
    Carnival.batch_action_items.push(value);
  }else{
    $(this).parent().parent().removeClass('batch_action_item_selected');
    Carnival.batch_action_items = Carnival.batch_action_items.filter(function(item){
      return item != value;
    })
  }
}
Carnival.batchActionSelected = function(){
  Carnival.batch_action_items = []
  $('.batch_action_items').click(Carnival.batchActionFunction);
}

Carnival.batchActionSuccessCallback = function(data, status, jqXHR){
  Carnival.reloadIndexPage();
}

Carnival.batchActionErrorCallback = function(jqXHR, status, error){
  Carnival.reloadIndexPage();
}
