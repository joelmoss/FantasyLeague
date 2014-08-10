class TeamPlayer < ActiveRecord::Base

  belongs_to :player
  belongs_to :team

  delegate :full_position, :position, :club, :seasons, :to_s, :short_name, to: :player

  validates :team_id, presence: true
  validates :purchase_price, presence: true

end
