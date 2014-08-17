class Fixture < ActiveRecord::Base

  has_many :fixture_players
  has_many :players, through: :fixture_players do
    def for_team(team)
      team.team_sheets.find_by(date: proxy_association.owner.date.to_date)
    end
  end
  belongs_to :home_club, class_name: 'Club'
  belongs_to :away_club, class_name: 'Club'

  default_scope { order :date, :time }


  def date
    read_attribute(:date).to_s(:rfc822)
  end

  def time
    read_attribute(:time).strftime '%l:%M %P'
  end

  def points_for_team(team)
    metrics = Hash.new(FixturePlayer::METRICS.keys)
    metrics.default = 0
    playing = team.team_sheets.where(date: date.to_date).pluck(:player_id)
    fixture_players.where(player_id: playing).each do |fp|
      FixturePlayer::METRICS.keys.each do |m|
        metrics[m] = metrics[m] + fp[m]
      end
    end
    metrics
  end

  def players_for_team(team)
    playing = team.team_sheets.where(date: date.to_date).pluck(:player_id)
    fixture_players.where(player_id: playing)
  end

end
