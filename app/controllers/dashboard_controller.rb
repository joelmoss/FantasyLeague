class DashboardController < ApplicationController

  before_action :authenticate_manager!, :require_mobile!

  def index
    @league = Team.all.sort_by(&:current_points).reverse
    @unaproved_managers = Manager.unapproved
    @activities = PublicActivity::Activity.all.order(created_at: :desc).limit(30)
    @results = Fixture.all.limit(25)
    @transfer_listed = Player.includes(:team_player, :club, :season).transfer_listed

    @team_results = Fixture.order(:date).group_by(&:date).map do |d,fixtures|
      {
        date: d.to_date,
        fixtures: FixtureTeam.where(fixture: fixtures).includes(:team).group_by(&:team_id)
      }
    end.first
  end

end
