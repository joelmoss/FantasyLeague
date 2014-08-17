# TODO: send notification when player is destroyed (no longer playing in PL)
class Player < ActiveRecord::Base

  include PublicActivity::Model
  tracked params: { old_club: :club_id_was, new_club: :club_id },
          on: {
            create: proc { |model| !model.image.blank? },
            update: proc { |model, controller|
              model.club_id_changed?
            }
          }
  acts_as_paranoid
  default_scope { order(:club_id, :position).where("image != ''") }

  has_many :seasons, class_name: 'PlayerSeason'
  has_many :previous_seasons, -> { where.not(season: Date.today.year) }, class_name: 'PlayerSeason'
  has_one :previous_season, -> { where(season: Date.today.year-1) }, class_name: 'PlayerSeason'
  has_one :season, -> { where(season: Date.today.year) }, class_name: 'PlayerSeason'
  has_one :team_player, validate: true
  has_one :team, through: :team_player
  has_many :watches
  has_many :watchers, through: :watches, source: :manager
  belongs_to :club
  has_many :fixture_players
  has_many :fixtures, through: :fixture_players

  accepts_nested_attributes_for :team_player

  POSITIONS = [
    {
      title: 'Goalkeeper',
      abbr: 'g'
    },
    {
      title: 'Full-back',
      abbr: 'f'
    },
    {
      title: 'Centre-back',
      abbr: 'c'
    },
    {
      title: 'Midfielder',
      abbr: 'm'
    },
    {
      title: 'Striker',
      abbr: 's'
    }
  ]


  def to_s
    full_name
  end

  def position
    POSITIONS[read_attribute(:position)][:abbr].upcase
  end

  def full_position
    POSITIONS[read_attribute(:position)][:title]
  end

  def free_agent?
    !team_player.present?
  end

end
