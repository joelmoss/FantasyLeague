class FixturesController < ApplicationController
  before_action :authenticate_manager!
  add_breadcrumb 'Fixtures', :fixtures_path


  def index
    @fixtures = Fixture.all.includes(:home_club, :away_club)
  end

  def show
    @fixture = Fixture.find(params[:id])
    add_breadcrumb @fixture, @fixture
  end

end
