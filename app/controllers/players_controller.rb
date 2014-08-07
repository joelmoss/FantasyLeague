class PlayersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_player, only: [ :show, :edit, :update, :destroy, :approve, :watch, :unwatch ]

  add_breadcrumb 'Players', :players_path


  def index
    @grid = PlayersGrid.new(params[:players_grid])
  end

  def show
    add_breadcrumb @player.short_name, @player
  end

  def watch
    current_manager.watchings << @player
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to @player
  end

  def unwatch
    current_manager.watchings.delete @player
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to @player
  end

  def watching
    @grid = PlayersWatchedGrid.new(params[:players_grid]) do
      current_manager.watchings
    end
    add_breadcrumb 'Watch list', watching_players_path
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

end
