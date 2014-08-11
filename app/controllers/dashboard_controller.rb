class DashboardController < ApplicationController

  before_action :authenticate_manager!

  def index
    @league = Team.all
    @unaproved_managers = Manager.unapproved
    @activities = PublicActivity::Activity.all.order created_at: :desc
  end

end
