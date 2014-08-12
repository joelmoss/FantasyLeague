$ ->

  unless $('body').hasClass 'teams index'
    return


  $('#teams-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: [4,5], orderable: false } ]