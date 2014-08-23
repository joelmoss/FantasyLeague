class Team < ActiveRecord::Base

  include PublicActivity::Model
  tracked only: [ :create ]

  belongs_to :manager
  has_many :team_sheets
  has_many :seasons, class_name: "TeamSeason" do
    def current
      year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
      find_by(season: year)
    end
  end
  has_many :team_players
  has_many :players, through: :team_players do
    def substitutes
      proxy_association.owner.team_players.where substitute: true
    end

    def starting_lineup
      proxy_association.owner.team_players.where substitute: false
    end

    def teamsheet
      proxy_association.owner.team_players.where starting: true
    end
  end

  default_scope { order :name }

  DEFAULT_BUDGET = 100.0
  FORMATIONS = %w( 4-4-2 5-3-2 4-5-1 5-4-1 4-3-3 )
  WEEK_PRIZES = [ 1, 0.5, 0.2 ]
  MONTH_PRIZES = [ 2, 1, 0.5 ]

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name
  end

  def budget
    (val = read_attribute(:budget)).blank? ? DEFAULT_BUDGET : val
  end

  def current_points
    seasons.current.try(:tot) || 0
  end

  def award_week_prize!(place)
    prize = WEEK_PRIZES[place]
    increment! :budget, prize
    create_conversation 'Team of the Week', 'You and your team have been declared as the Team of '+
                                            "Week and have been awarded a prize of £#{prize}m."
  end

  def award_month_prize!(place)
    prize = MONTH_PRIZES[place]
    increment! :budget, prize
    create_conversation 'Team of the Month', 'You and your team have been declared as the Team of '+
                                             "Month and have been awarded a prize of £#{prize}m."
  end

  def formation(additional_player = false)
    groups = players.starting_lineup.includes(:player).group_by(&:position)

    if additional_player
      groups[additional_player.position] = [] if groups[additional_player.position].nil?
      groups[additional_player.position] << additional_player
    end

    # 1 goalkeeper
    return false if (groups['G'].try(:count) || 0) != 1

    # 2 full-backs
    return false if (groups['F'].try(:count) || 0) != 2

    cb = groups['C'].try(:count) || 0
    md = groups['M'].try(:count) || 0
    st = groups['S'].try(:count) || 0

    # Return the formation
    return '4-4-2' if cb == 2 && md == 4 && st == 2
    return '5-3-2' if cb == 3 && md == 3 && st == 2
    return '4-5-1' if cb == 2 && md == 5 && st == 1
    return '5-4-1' if cb == 3 && md == 4 && st == 1
    return '4-3-3' if cb == 2 && md == 3 && st == 3

    false
  end


  private

    def create_conversation(subject, body)
      con = Conversation.create subject: subject, creator: manager, recipient: manager
      con.messages.create manager: manager, body: body
    end

end
