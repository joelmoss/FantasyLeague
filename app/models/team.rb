class Team < ActiveRecord::Base

  belongs_to :manager
  has_many :team_players
  has_many :players, through: :team_players

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name
  end

end
