class TeamPlayer < ActiveRecord::Base

  belongs_to :player
  belongs_to :team

  delegate :full_position, :position, :club, :seasons, :to_s, :short_name, to: :player

  validate :valid_squad?
  validates :team_id, presence: true
  validates :purchase_price, presence: true

  after_create :recalculate_team_budget


  private

    def recalculate_team_budget
      team.update_attribute :budget, team.budget - purchase_price
    end

    def valid_squad?
      errors.add :base, "Team '#{team}' cannot have more than 2 players per club." unless valid_club_quota?
      errors.add :base, "Team '#{team}' cannot have more than 16 players." unless valid_max_size?
      errors.add :base, "Team '#{team}' cannot have a negative budget." unless valid_budget?
    end

    def valid_budget?
      (team.budget - purchase_price) >= 0
    end

    def valid_club_quota?
      grouped = team.players.group_by(&:club_id)
      if grouped[player.club_id].nil?
        grouped[player.club_id] = []
      else
        grouped[player.club_id] << player
      end
      !grouped.any? { |k,v| v.count > 2 }
    end

    def valid_max_size?
      team.players.count < 15
    end

end
