$ ->

  unless $('body').hasClass 'players index'
    return

  playerTable = $('#player-list').DataTable
    order: []
    pageLength: 25
    columnDefs: [ { targets: [2,11], orderable: false } ]


  $("select#player-filter-position").on 'change', ->
    val = $(@).val()
    playerTable.column(0).search((if val then "^#{val}$" else val), true, false).draw()

  $("select#player-filter-club").on 'change', ->
    val = $(@).val()
    playerTable.column(2).search((if val then "^#{val}$" else val), true, false).draw()

  $("select#player-filter-team").on 'change', ->
    val = $(@).val()
    playerTable.column(3).search((if val then "^#{val}$" else val), true, false).draw()


  watchBtn = $('#player-list')
  watchBtn.on 'ajax:before', '.toggle-watch-player.btn', (event, xhr, status)->
    $(@).text 'saving...'
  watchBtn.on 'ajax:success', '.toggle-watch-player.btn', (event, xhr, status)->
    ele = $(@)
    ele.toggleClass('btn-success').toggleClass('btn-default')
    if ele.data('watched')
      ele.text('watch').data 'watched', false
    else
      ele.text('unwatch').data 'watched', true