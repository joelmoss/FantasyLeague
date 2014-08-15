$ ->

  unless $('body').hasClass 'teams index'
    return


  $('#teams-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: [5,6], orderable: false } ]