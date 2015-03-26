Carnival.batchActionInitialize = function(noItemsMessage){
  Carnival.batchActionSelected();
  Carnival.batchActionToggleAllItems();
  Carnival.batchActionSubmit(noItemsMessage);
}

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

Carnival.batchActionToggleAllItems = function(){
  $('#toggle-all-batch-actions-items').click(function(){
    var checked = this.checked;
    $('.batch_action_items').each(function(){
      $(this).prop('checked', checked).triggerHandler('click');
    });
  });
}

Carnival.batchActionSubmit = function(noItemsMessage){
  $('.batch_action_button').click(function(){
    if(Carnival.batch_action_items.length == 0){
      alert(noItemsMessage);
      return false;
    }
    $(this).parents('form').append('<input type="hidden" value="' + Carnival.batch_action_items + '" name="batch_action_items" />');
  });
}

Carnival.batchActionSuccessCallback = function(data, status, jqXHR){
  Carnival.reloadIndexPage();
}

Carnival.batchActionErrorCallback = function(jqXHR, status, error){
  Carnival.reloadIndexPage();
}
