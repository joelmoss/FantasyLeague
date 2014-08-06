class Player < ActiveRecord::Base

  has_many :seasons, class_name: 'PlayerSeason'
  has_one :team_player
  has_one :team, through: :team_player

  POSITIONS = {
    g: 'Goalkeeper',
    f: 'Full-back',
    c: 'Centre-back',
    m: 'Midfielder',
    s: 'Striker'
  }

  CLUBS = {
    ars: 'Arsenal',
    av: 'Aston Villa',
    bur: 'Burnley',
    che: 'Chelsea',
    cp: 'Crystal Palace',
    eve: 'Everton',
    hul: 'Hull',
    lei: 'Leicester',
    liv: 'Liverpool',
    mc: 'Manchester City',
    mu: 'Manchester United',
    new: 'Newcastle',
    qpr: 'Queens Park Rangers',
    sot: 'Southampton',
    sto: 'Stoke City',
    sun: 'Sunderland',
    swa: 'Swansea',
    tot: 'Tottenham Hotspurs',
    wba: 'West Bromwich Albion',
    wh: 'West Ham United'
  }


  def to_s
    full_name
  end

  def position
    read_attribute(:position).upcase
  end

  def full_position
    POSITIONS[read_attribute(:position).to_sym]
  end

  def club_name
    CLUBS[read_attribute(:club).downcase.to_sym]
  end

  def free_agent?
    !team_player.present?
  end

end
