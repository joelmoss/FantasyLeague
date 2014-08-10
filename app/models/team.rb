class Team < ActiveRecord::Base

  belongs_to :manager
  has_many :team_players
  has_many :players, through: :team_players

  DEFAULT_BUDGET = 100.0

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name
  end

  def budget
    (val = read_attribute(:budget)).blank? ? DEFAULT_BUDGET : val
  end

end
