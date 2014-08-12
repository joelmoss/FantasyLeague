$ ->

  # Enable tooltips
  $('[data-toggle=tooltip]').tooltip()

  loadScreen = $('#load-screen')
  doc = $(document)
  doc.on "page:fetch", ->
    loadScreen.fadeIn()
  doc.on "page:change", ->
    loadScreen.fadeOut()
  doc.on "page:load", ->
    loadScreen.fadeOut()


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


