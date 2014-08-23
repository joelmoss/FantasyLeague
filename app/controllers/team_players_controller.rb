class TeamPlayersController < ApplicationController

  before_action :authenticate_manager!, :require_mobile!
  before_action :set_player, only: [ :show, :toggle_sub, :toggle_transfer_listed, :release ]


  def show
    add_breadcrumb @player.short_name, team_player_path
  end

  def toggle_sub
    if @player.toggle!(:substitute)
      respond_to do |format|
        format.html { redirect_to(:back) }
        format.json {
          render status: :created, json: { status: render_to_string(partial: 'teams/status') }
        }
      end
    else
      @msg = "Player cannot be substituted. #{@player.errors.to_hash.values.first.first}"
      respond_to do |format|
        format.html { redirect_to :back, alert: @msg }
        format.json {
          render status: :precondition_failed, json: { status: render_to_string(partial: 'teams/status'),
                                                       message: @msg }
        }
      end
    end
  rescue ActionController::RedirectBackError
    redirect_to team
  end

  def toggle_transfer_listed
    @player.toggle!(:transfer_listed)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to team
  end

  def release
    @player.destroy
    redirect_to team
  end


  private

    def set_player
      @player = team.team_players.with_deleted.find(params[:id])
      if @player.destroyed?
        redirect_to (@player.player || team), alert: 'This player no longer plays for this team or is not on the player list'
      end
    end

    def team
      @team ||= Team.find(params[:team_id]).tap do |team|
        add_breadcrumb 'Teams', :teams_path
        add_breadcrumb team, team
        add_breadcrumb 'Players', team
      end
    end

end
