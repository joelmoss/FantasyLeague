class PlayersController < ApplicationController

  before_action :authenticate_manager!


  def index
    @players = Player.all
  end

end
