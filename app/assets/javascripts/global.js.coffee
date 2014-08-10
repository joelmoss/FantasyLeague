$ ->

  # Enable tooltips
  $('[data-toggle=tooltip]').tooltip()


  $('#managers-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: [0,1,4,5], orderable: false } ]


  $('#teams-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: [2,3], orderable: false } ]


  watchBtn = $('body.players.show .toggle-watch-player')
  watchBtn.on 'ajax:before', (event, xhr, status)->
    $(@).text 'saving...'
  watchBtn.on 'ajax:success', (event, xhr, status)->
    ele = $(@)
    ele.toggleClass('btn-success').toggleClass('btn-default')
    if ele.data('watched')
      ele.text('watch player').data 'watched', false
    else
      ele.text('stop watching').data 'watched', true


