class TeamsController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_team, only: [ :show, :edit, :update, :destroy, :approve ]

  add_breadcrumb 'Teams', :teams_path


  # GET /teams
  def index
    @teams = Team.all.sort_by(&:current_points).reverse
  end

  def new
    @team = current_manager.build_team
  end

  # POST /teams
  def create
    @team = current_manager.build_team(team_params)
    if @team.save
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  # GET /teams/1/edit
  def edit
    add_breadcrumb @team, @team
    add_breadcrumb 'Edit', [:edit, @team]
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  def show
    add_breadcrumb @team, @team
    @squad = @team.team_players.includes(player: :club).joins(:player).order 'substitute ASC, players.position ASC'
    @teamsheet = @team.players.teamsheet.includes(player: :club).joins(:player).order 'players.position'
    @results = Fixture.all.group(:id, :date).includes(:home_club, :away_club, :fixture_players)
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :manager_id)
    end

end
