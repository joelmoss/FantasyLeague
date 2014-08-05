class TeamPlayersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_player, only: [ :show, :edit, :update, :destroy, :approve ]


  def show
    add_breadcrumb @player.short_name, team_player_path
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = team.team_players.find(params[:id])
    end

    def team
      @team ||= Team.find(params[:team_id]).tap do |team|
        add_breadcrumb 'Teams', :teams_path
        add_breadcrumb team, team
        add_breadcrumb 'Players', team
      end
    end

end
