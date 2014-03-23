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
    $(".advanced_search input").each(function(){
      if($(this).attr("type") == "checkbox")
        queryParams.push(generateQueryParam($(this).attr("name"), $(this).data("type"), $(this).data("operator"), $(this).is(":checked")));
      else if ($(this).attr("type") == "text" && $(this).val() != "")
        queryParams.push(generateQueryParam($(this).attr("name"), $(this).data("type"), $(this).data("operator"), $(this).val()));
    });
    $(".advanced_search select").each(function(){
      if($(this).val() != "-1")
        queryParams.push(generateQueryParam($(this).attr("name"), $(this).data("type"), $(this).data("operator"), $(this).val()));
    });
    $(".table").first().data("advancedquery", "{" + queryParams.join(", ") + "}");
    var dataTable = $(".table").dataTable();
    dataTable.fnReloadAjax(generateDataSource($(".table")));
  });

  $("#clear_button").click(function(e){
    e.preventDefault();
    $($(this).parent().parent().parent()).trigger("reset")
    $(".table").first().data("advancedquery", "");
    $(".dataTables_filter input[type=text]").val("");
    var dataTable = $(".table").dataTable();
    dataTable.fnReloadAjax(generateDataSource($(".table")));
  });
});

function generateQueryParam(field, association, operator, value){
  return '"' + field + '":{"operator":"' + operator + '", "value":"' + value + '", "type":"' + association + '"}'
}
