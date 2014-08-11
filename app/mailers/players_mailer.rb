class PlayersMailer < ActionMailer::Base
  default from: "joel@developwithstyle.com"


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.players.new_player.subject
  #
  def new_players(new_players, old_players, changed_club)
    @new_players = new_players
    @old_players = old_players
    @changed_club = changed_club
    Manager.all.each do |manager|
      mail to: manager.email, subject: 'Fantasy League Player changes'
    end


  end
end
