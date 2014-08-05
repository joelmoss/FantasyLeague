class PlayersController < ApplicationController

  before_action :authenticate_manager!

  add_breadcrumb 'Players', :players_path


  def index
    @players = Player.all
  end

end
