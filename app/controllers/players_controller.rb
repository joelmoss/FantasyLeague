class PlayersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_player, only: [ :show, :edit, :update, :destroy, :approve ]

  add_breadcrumb 'Players', :players_path


  def index
    @grid = PlayersGrid.new(params[:players_grid])
  end

  def show
    add_breadcrumb @player.short_name, @player
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

end
