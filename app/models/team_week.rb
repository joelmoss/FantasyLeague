class TeamWeek < ActiveRecord::Base

  belongs_to :team


  def self.current_season
    year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
    where season: year
  end

  def self.this_week
    current_season.where week_beginning: Date.today.beginning_of_week
  end

  def self.last_week
    current_season.where week_beginning: Date.today.last_week.beginning_of_week
  end

end
