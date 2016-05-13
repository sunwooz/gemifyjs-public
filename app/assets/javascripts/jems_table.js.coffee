jQuery ->
  $('.datatable').DataTable({
    "sPaginationType": "bootstrap",
    "oLanguage": {
      "sLengthMenu": 'Display <select>'+
        '<option value="20">20</option>'+
        '<option value="30">30</option>'+
        '<option value="40">40</option>'+
        '<option value="50">50</option>'+
        '<option value="-1">All</option>'+
        '</select> records'
    },
    "iDisplayLength": 50,
    "bAutoWidth": false,
    "aaSorting": [[4,'desc']],

    "fnInitComplete": () ->
        $("#table_filter input").addClass("form-control")
        $("#table_filter label").text("")
        $("#table_filter label").append("<span class='glyphicon glyphicon-search'></span> <input type='text' aria-controls='table' class='form-control' placeholder='Search'>")
        $("#jems-table").show()
        this.fnAdjustColumnSizing()
    
  })

  $('#index-tab a').click((e) ->
    e.preventDefault()
    $(this).tab('show')
  )