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


  # Toggle team sub
  toggleSub = $('.toggle-sub')
  toggleSub.on 'ajax:before', ->
    $(@).toggleClass 'highlight'
  toggleSub.on 'ajax:error', (event, xhr)->
    $(@).toggleClass 'highlight'

    drop = new Drop
      target: @
      classes: 'drop-theme-arrows-bounce-dark'
      content: xhr.responseText
      position: 'top left'
    drop.open()
