$ ->

  unless $('body').hasClass 'teams index'
    return


  $('#teams-list').DataTable
    paging: false
    order: []
