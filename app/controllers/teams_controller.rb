class TeamsController < ApplicationController

  before_action :authenticate_manager!, :require_mobile!
  before_action :set_team, only: [ :show, :team_sheet, :results, :edit, :update, :destroy, :approve ]

  add_breadcrumb 'Teams', :teams_path


  # GET /teams
  def index
    @teams = Team.all.sort_by(&:current_points).reverse
  end

  def weeks
    year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
    @weeks = TeamWeek.where(season: year).order(week: :desc).group_by(&:week)
  end

  def months
    year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
    @months = TeamMonth.where(season: year).order(month: :desc).group_by(&:month)
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
  end

  def team_sheet
    @teamsheet = @team.players.teamsheet.includes(player: :club).joins(:player).order 'players.position'
    render layout: false
  end

  def results
    @results = Fixture.all.group(:id, :date).includes(:home_club, :away_club, :fixture_players)
    render layout: false
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
