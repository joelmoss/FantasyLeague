class TeamPlayer < ActiveRecord::Base

  belongs_to :player
  belongs_to :team

  delegate :full_position, :position, :club, :seasons, :to_s, :short_name, to: :player

end
