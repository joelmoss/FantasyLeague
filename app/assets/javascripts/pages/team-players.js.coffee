$ ->

  unless $('body').hasClass 'teams show'
    return


  teamPlayerTable = $('#team-player-list').DataTable
    paging: false
    order: []

  $("select#player-filter-position").on 'change', ->
    val = $(@).val()
    teamPlayerTable.column(1).search((if val then "^#{val}$" else val), true, false).draw()

  $("select#player-filter-club").on 'change', ->
    val = $(@).val()
    teamPlayerTable.column(3).search((if val then "^#{val}$" else val), true, false).draw()
