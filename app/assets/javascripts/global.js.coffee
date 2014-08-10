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

  $('#player-list').DataTable
    order: []
    pageLength: 25
    columnDefs: [ { targets: 10, orderable: false } ]

  $('#team-player-list').DataTable
    paging: false
    order: []


  watchBtn = $('#player-list .toggle-watch-player.btn')
  watchBtn.on 'ajax:before', (event, xhr, status)->
    $(@).text 'saving...'
  watchBtn.on 'ajax:success', (event, xhr, status)->
    ele = $(@)
    ele.toggleClass('btn-success').toggleClass('btn-default')
    if ele.data('watched')
      ele.text('watch').data 'watched', false
    else
      ele.text('unwatch').data 'watched', true


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


  watchTable = $('#player-watch-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: 10, orderable: false } ]

  watchBtn = $('#player-watch-list .toggle-watch-player.btn')
  watchBtn.on 'ajax:before', (event, xhr, status)->
    $(@).text 'unwatching...'
  watchBtn.on 'ajax:success', (event, xhr, status)->
    watchTable.row($(@).parents('tr')).remove().draw()
