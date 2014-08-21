class DashboardController < ApplicationController

  before_action :authenticate_manager!, :require_mobile!

  def index
    @league = Team.all.sort_by(&:current_points).reverse
    @unaproved_managers = Manager.unapproved
    @activities = PublicActivity::Activity.all.order(created_at: :desc).limit(20)
    @results = Fixture.all
  end

end
