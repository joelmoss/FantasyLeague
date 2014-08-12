$ ->

  unless $('body').hasClass 'managers'
    return


  $('#managers-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: [0,4,5], orderable: false } ]