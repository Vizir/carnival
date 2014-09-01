function datatable_list(table, ordered_columns, sorting, filter){
  if (sorting == undefined){
    var sorting = 0
  }
  if (filter == undefined){
    var filter = true
  }
  if (length == undefined){
    var length = 50
  }
  var asInitVals = new Array();
  var remote = false

  if ($(table).data('source') != null)
    remote = true;

  var search = false

  if ($(table).data('search') != null)
    search = true;

  var notSortableColumns = []
  var columnIndex = 0;

  $(table).find("th").each(function(index, item){
    if(!$(item).data("sortable"))
      notSortableColumns.push(index);
  });

  var tableConfiguration = {
   "aoColumnDefs": [
        {
         bSortable: false,
         aTargets: notSortableColumns
        }
      ] ,
    "bFilter": filter,
    "bProcessing": remote,
    "bServerSide": remote,
    'sAjaxSource': generateDataSource(table),
    'fnDrawCallback': function(oSettings){
      scopes = oSettings.jqXHR.responseJSON.scope_counters;
      if (scopes !== undefined) {
        scopes.forEach(function(scope) {
          Carnival.setScopeNumber(scope.scope, scope.count);
        });
      }
      Carnival.batchActionSelected();
    },
    "sPaginationType": "full_numbers",
    "iDisplayLength": length,
    "bRetrieve": true,
    "fnServerParams": function(){
      $(".dataTables_processing").width($(".dataTable").width());
      $(".dataTables_processing").height($(".dataTable").height() + 40);
      $(".dataTables_processing").html("<div class='datatables-loading'>Processando</div>")
    },
    'oLanguage': dataTablesTranslation
  }
  
  tableConfiguration.aaSorting = getSorting(table);

  var oTable = $(table).dataTable(tableConfiguration);

  if(!search)
    $(".dataTables_filter").hide();
}

function generateDataSource(table){
  var url = $(table).data('source');
  url = addUrlParam(url, "scope", table);
  url = addUrlParam(url, "special_scope", table);
  url = addUrlParam(url, "from", table);
  url = addUrlParam(url, "to", table);
  url = addUrlParam(url, "advancedquery", table);
  return url;
}

function getSorting(table){
  var sortConfig = []
  $(table).find('th').each(function(index, elem){
    var sortableObj = $(elem).data('sortable');
    if(sortableObj && sortableObj.default){
      var direction = sortableObj.direction;
      sortConfig.push([ index, direction ]);
    }
  });
  return sortConfig;
}

function addUrlParam(url, param, table){
  if($(table).data(param) != undefined && $(table).data(param) != ""){
    if(url.indexOf("?") > 0)
      url = url + "&";
    else
      url = url + "?";
    return url + param + "=" + encodeURI($(table).data(param));
  }
  else
    return url;
}
