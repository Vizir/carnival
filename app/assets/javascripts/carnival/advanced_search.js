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
    $("#advanced_search_form input").each(function(){
      var inputType = $(this).attr("type");
      var inputName = $(this).attr("name");
      var inputOperator = $(this).data("operator");
      var inputValue = $(this).val();

      if(inputType == "checkbox")
        queryParams.push(generateQueryParam(inputName, inputType, inputOperator, $(this).is(":checked")));
      else if (inputType == "text"){
        if(inputValue != "" && inputValue != "____/__/__")
          queryParams.push(generateQueryParam(inputName, inputType, inputOperator, inputValue));
      }
    });

    $("#advanced_search_form select").each(function(){
      var inputType = $(this).attr("type");
      var inputName = $(this).attr("name");
      var inputOperator = $(this).data("operator");
      var inputValue = $(this).val();

      if(inputValue != "-1" && inputValue != "")
        queryParams.push(generateQueryParam(inputName, inputType, inputOperator, inputValue));
    });
    var advancedSearchParams = "{" + queryParams.join(", ") + "}";
    Carnival.setIndexPageParamAndReload('advanced_search', advancedSearchParams);
  });

  $("#clear_button").click(function(e){
    e.preventDefault();
    $($(this).parent().parent().parent()).trigger("reset")
    Carnival.setIndexPageParamAndReload('advanced_search', '');
  });
});

function generateQueryParam(field, association, operator, value){
  return '"' + field + '":{"operator":"' + operator + '", "value":"' + value + '", "type":"' + association + '"}'
}
