$(document).ready(function(){
  $("#advanced_search_toggler, ul#advanced_search_form").mouseover(function(e){
    $("#advanced_search_form").show();
  });

  $("#advanced_search_toggler, ul#advanced_search_form").mouseout(function(e){
    $("#advanced_search_form").hide();
  });

  $("#search_button").click(function(e){
    e.preventDefault();

    var queryParams = [];

    Carnival.submitIndexForm();
  });

  $("#clear_button").click(function(e){
    e.preventDefault();
    $($(this).parent().parent().parent()).trigger("reset")
    $("#advanced_search_form input").each(function(){
      var inputValue = $(this).val();
      $(this).val('');
    });

    $("#advanced_search_form select").each(function(){
      var inputValue = $(this).val();
      $(this).val('');
    });
    Carnival.submitIndexForm();
  });
});


