class Fixture < ActiveRecord::Base

  has_many :fixture_players do
    def home
      joins(:player).includes(:player).where('players.club_id' => proxy_association.owner.home_club).order('players.position')
    end
    def starters
      where subbed_on: false
    end
    def subs
      where subbed_on: true
    end
    def away
      joins(:player).includes(:player).where('players.club_id' => proxy_association.owner.away_club).order('players.position')
    end
  end
  has_many :players, through: :fixture_players do
    def for_team(team)
      team.team_sheets.find_by(date: proxy_association.owner.date.to_date)
    end
  end
  belongs_to :home_club, class_name: 'Club'
  belongs_to :away_club, class_name: 'Club'

  default_scope { order date: :desc, time: :asc }


  def to_s
    "#{home_club} vs. #{away_club}"
  end

  def date
    read_attribute(:date).to_s(:rfc822)
  end

  def time
    read_attribute(:time).strftime '%l:%M %P'
  end

  def points_for_team(team)
    metrics = Hash.new(FixturePlayer::METRICS.keys)
    metrics.default = 0
    playing = team.team_sheets.where(date: date.to_date - 1).pluck(:player_id)
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
