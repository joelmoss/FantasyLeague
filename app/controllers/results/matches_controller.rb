class Results::MatchesController < ApplicationController
  before_action :authenticate_manager!, :require_mobile!
  add_breadcrumb 'Matches', :results_matches_path


  def index
    @fixtures = Fixture.all.includes(:home_club, :away_club)
  end

  def show
    @fixture = Fixture.find(params[:id])
    add_breadcrumb @fixture, results_match_path(@fixture)
  end


  private

    def results?
      true
    end

end
