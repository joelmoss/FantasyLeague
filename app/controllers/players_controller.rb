class PlayersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_player, only: [ :show, :edit, :update, :destroy, :approve ]

  add_breadcrumb 'Players', :players_path


  def index
    @players = Player.all
  end

  # GET /players/1
  def show
    add_breadcrumb @player, @player
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

end
