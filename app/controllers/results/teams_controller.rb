class Results::TeamsController < ApplicationController
  before_action :authenticate_manager!, :require_mobile!
  add_breadcrumb 'Team Results', :results_teams_path


  def index
    @fixtures = Fixture.order(date: :desc).group_by(&:date)
  end

  def show
    fixtures = Fixture.where(date: params[:id])
    @teams = FixtureTeam.where(fixture: fixtures).group_by(&:team_id)
    add_breadcrumb params[:id].to_date.to_s(:short)
  end


  private

    def results?
      true
    end

end
