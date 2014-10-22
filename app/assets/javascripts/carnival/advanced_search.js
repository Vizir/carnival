$(document).ready(function(){
  $("#advanced_search_toggler").click(function(e){
    $('body').append('<div class="as-form-overlay">')
    $("#advanced_search_toggler").toggleClass('is-opened')
    $("#advanced_search_form").toggle();
    $(".as-form-overlay").click(function(e){
      $(".as-form-overlay").remove();
      $("#advanced_search_form").hide();
      $(".select2-drop").hide();      
      return false
    });
    return false
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


