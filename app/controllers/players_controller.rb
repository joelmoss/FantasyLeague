class PlayersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_player, only: [ :show, :update, :toggle_watch ]

  add_breadcrumb 'Players', :players_path


  def index
    @players = Player.includes(:team_player, :club, :previous_season, :team, :watchers)
  end

  def show
    add_breadcrumb @player.short_name, @player
  end

  def update
    if @player.update(player_params)
      redirect_to @player, notice: 'Player was successfully updated.'
    else
      redirect_to @player, alert: 'Player was not updated.'
    end
  end

  def toggle_watch
    if current_manager.watchings.include? @player
      current_manager.watchings.delete @player
    else
      current_manager.watchings << @player
    end
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to @player
  end

  def watching
    @players = current_manager.watchings.includes(:club, :team, :previous_season, :team_player)
    add_breadcrumb 'Watch list', watching_players_path
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def player_params
      params.require(:player).permit(team_player_attributes: [ :team_id, :purchase_price ])
    end

end
