class TeamPlayersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_player, only: [ :show, :toggle_sub ]


  def show
    add_breadcrumb @player.short_name, team_player_path
  end

  def toggle_sub
    if @player.toggle(:substitute).save
      respond_to do |format|
        format.html { redirect_to(:back) }
        format.js { head(:created) }
      end
    else
      @msg = "Player cannot be substituted. #{@player.errors.to_hash.values.first.first}"
      respond_to do |format|
        format.html { redirect_to :back, alert: @msg }
        format.js { render status: :precondition_failed, text: @msg }
      end
    end
  rescue ActionController::RedirectBackError
    redirect_to team
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
