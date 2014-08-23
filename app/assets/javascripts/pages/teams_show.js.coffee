$ ->

  unless $('body').hasClass 'teams show'
    return


  teamPlayerTable = $('#team-player-list').DataTable
    paging: false
    order: []
    columnDefs: [ { targets: 3, orderable: false } ]

  $("select#player-filter-position").on 'change', ->
    val = $(@).val()
    teamPlayerTable.column(1).search((if val then "^#{val}$" else val), true, false).draw()

  $("select#player-filter-club").on 'change', ->
    val = $(@).val()
    teamPlayerTable.column(4).search((if val then "^#{val}$" else val), true, false).draw()


  # Toggle team sub
  toggleSub = $('.toggle-sub')
  status = $('#team-status')
  toggleSub.on 'ajax:before', ->
    $(@).toggleClass 'highlight'
  toggleSub.on 'ajax:complete', (event, xhr)->
    status.html xhr.responseJSON.status
  toggleSub.on 'ajax:error', (event, xhr)->
    $(@).toggleClass 'highlight'

    drop = new Drop
      target: @
      classes: 'drop-theme-arrows-bounce-dark'
      content: xhr.responseJSON.message
      position: 'top left'
    drop.open()


  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e)->
    target = $(e.target)
    ele = $(".tab-content #{target.data('target')}")
    if ele.is(':empty')
      ele.html '<i class="fa fa-cog fa-spin fa-2x"></i>'
      ele.load target.attr('href')
