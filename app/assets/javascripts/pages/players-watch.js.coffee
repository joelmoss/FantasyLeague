$ ->

  unless $('body').hasClass 'players watching'
    return

  watchTable = $('#player-watch-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: [2,11], orderable: false } ]

  $("select#player-filter-position").on 'change', ->
    val = $(@).val()
    watchTable.column(0).search((if val then "^#{val}$" else val), true, false).draw()

  $("select#player-filter-club").on 'change', ->
    val = $(@).val()
    watchTable.column(3).search((if val then "^#{val}$" else val), true, false).draw()

  $("select#player-filter-team").on 'change', ->
    val = $(@).val()
    watchTable.column(4).search((if val then "^#{val}$" else val), true, false).draw()


  watchBtn = $('#player-watch-list')
  watchBtn.on 'ajax:before', '.toggle-watch-player.btn', (event, xhr, status)->
    $(@).text 'unwatching...'
  watchBtn.on 'ajax:success', '.toggle-watch-player.btn', (event, xhr, status)->
    watchTable.row($(@).parents('tr')).remove().draw()