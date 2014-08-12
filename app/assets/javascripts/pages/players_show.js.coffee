$ ->

  unless $('body').hasClass 'players show'
    return


  $('#player_team_player_attributes_team_id').on 'change', ->
    $('#player_team_player_attributes_purchase_price').focus()