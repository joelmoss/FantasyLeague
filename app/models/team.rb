class Team < ActiveRecord::Base

  belongs_to :manager
  has_many :squads
  has_many :players, through: :squads

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name
  end

end
