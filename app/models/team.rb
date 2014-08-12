class Team < ActiveRecord::Base

  include PublicActivity::Model
  tracked only: [ :create ]

  belongs_to :manager
  has_many :team_players
  has_many :players, through: :team_players do
    def substitutes
      proxy_association.owner.team_players.where substitute: true
    end

    def starting_lineup
      proxy_association.owner.team_players.where substitute: false
    end
  end

  DEFAULT_BUDGET = 100.0
  FORMATIONS = %w( 4-4-2 5-3-2 4-5-1 5-4-1 4-3-3 )

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name
  end

  def budget
    (val = read_attribute(:budget)).blank? ? DEFAULT_BUDGET : val
  end

  def formation(additional_player = false)
    groups = players.starting_lineup.group_by(&:position)

    if additional_player
      groups[additional_player.position] = [] if groups[additional_player.position].nil?
      groups[additional_player.position] << additional_player
    end

    p "G:#{groups['G'].count}"
    p "F:#{groups['F'].count}"
    p "C:#{groups['C'].count}"
    p "M:#{groups['M'].count}"
    p "S:#{groups['S'].count}"

    # 1 goalkeeper
    return false if groups['G'].count != 1

    # 2 full-backs
    return false if groups['F'].count != 2

    cb, md, st = groups['C'].count, groups['M'].count, groups['S'].count

    # Return the formation
    return '4-4-2' if cb == 2 && md == 4 && st == 2
    return '5-3-2' if cb == 3 && md == 3 && st == 2
    return '4-5-1' if cb == 2 && md == 5 && st == 1
    return '5-4-1' if cb == 3 && md == 4 && st == 1
    return '4-3-3' if cb == 2 && md == 3 && st == 3

    false
  end

end
