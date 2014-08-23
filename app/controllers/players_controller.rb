class PlayersController < ApplicationController

  before_action :authenticate_manager!, :require_mobile!
  before_action :set_player, only: [ :show, :update, :toggle_watch ]

  add_breadcrumb 'Players', :players_path

  rescue_from ActiveRecord::RecordNotFound, with: :player_not_found


  def index
    @players = Player.includes(:team_player, :club, :season, :team, :watchers)
  end

  def transfer_listed
    add_breadcrumb 'Transfer Listed'
    @players = Player.includes(:team_player, :club, :season, :team, :watchers).transfer_listed
  end

  def show
    add_breadcrumb @player.short_name, @player
    @sealed_bid = @player.sealed_bids.build manager: current_manager
  end

  def update
    if @player.update(player_params)
      redirect_to @player, notice: 'Player was successfully updated.'
    else
      redirect_to @player, alert: "Player was not updated. #{@player.errors.to_hash.values.first.first}"
    end
  end

  def toggle_watch
    if current_manager.watchings.include? @player
      current_manager.watchings.delete @player
    else
      current_manager.watchings << @player
    end

    request.xhr? ? head(:created) : redirect_to(:back)
  rescue ActionController::RedirectBackError
    redirect_to @player
  end

  def watching
    @players = current_manager.watchings.includes(:club, :team, :season, :team_player)
    add_breadcrumb 'Watch list', watching_players_path
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def player_params
      params.require(:player).permit(team_player_attributes: [ :team_id, :purchase_price ],
                                     sealed_bids_attributes: [ :bid ])
    end

    def player_not_found
      redirect_to :back, alert: 'Player does not exist in the player list.'
    rescue ActionController::RedirectBackError
      redirect_to players_url, alert: 'Player does not exist in the player list.'
    end

end
