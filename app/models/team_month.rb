class TeamMonth < ActiveRecord::Base

  belongs_to :team


  def self.current_season
    year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
    where season: year
  end

  def self.this_month
    current_season.where month_beginning: Date.today.beginning_of_month
  end

  def self.last_month
    current_season.where month_beginning: Date.today.last_month.beginning_of_month
  end

end
