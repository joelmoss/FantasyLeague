class TeamPlayer < ActiveRecord::Base

  acts_as_paranoid
  include PublicActivity::Model
  tracked params: { purchase_price: :purchase_price, old_team: :team_id_was, new_team: :team_id },
          on: {
            update: proc { |model| model.team_id_changed? }
          }

  belongs_to :player
  belongs_to :team

  delegate :full_position, :position, :seasons, :to_s, :short_name, to: :player

  validate :valid_squad?, on: [ :create, :destroy ]
  validate :valid_starting_lineup?, on: :update, if: Proc.new { |tp| tp.substitute_changed? }
  validates :team_id, presence: true
  validates :purchase_price, presence: true

  after_create :recalculate_team_budget


  def points_for_date(date)
    metrics = Hash.new(FixturePlayer::METRICS.keys)
    metrics.default = 0

    Fixture.where(date: date.to_date).each do |fixture|
      fixture.fixture_players.where(player: player).each do |fp|
        FixturePlayer::METRICS.keys.each do |m|
          metrics[m] = metrics[m] + fp[m]
        end
      end
    end if team.team_sheets.exists?(date: date.to_date - 1, player: player)

    metrics
  end

  # Returns the club_id for the given player as it was at the start of the season.
  def club_id
    club_changed_from || player.club_id
  end

  def club_changed?
    !club_changed_from.nil?
  end

  def club
    Club.find club_id
  end

  def actual_club
    player.club
  end


  private

    def recalculate_team_budget
      team.update_attribute :budget, team.budget - purchase_price
    end

    def valid_squad?
      errors.add :base, "Team '#{team}' cannot have more than 2 players per club." unless valid_club_quota?
      errors.add :base, "Team '#{team}' cannot have more than 15 players." unless valid_max_size?
      errors.add :base, "Team '#{team}' cannot have a negative budget." unless valid_budget?
    end

    def valid_max_starting_lineup?
      _count = team.players.starting_lineup.count
      _count = substitute_was ? _count + 1 : _count - 1

      errors.add :base, "Starting line-up cannot be more than 11 players." if _count > 11
      true
    end

    def valid_starting_lineup?
      valid_max_starting_lineup? && valid_formation?
    end

    # Only validates the formation on a full starting line-up of 11 players.
    def valid_formation?
      if substitute_was && team.players.starting_lineup.count == 10 && !team.formation(player)
        errors.add :base, "Starting line-up must be a valid formation (#{Team::FORMATIONS.join(', ')})."
      end
    end

    def valid_budget?
      (team.budget - purchase_price) >= 0
    end

    def valid_club_quota?
      grouped = team.team_players.group_by(&:club_id)
      grouped[player.club_id] = [] if grouped[player.club_id].nil?
      grouped[player.club_id] << player if new_record?
      !grouped.any? { |k,v| v.count > 2 }
    end

    def valid_max_size?
      team.players.count < 15
    end

end
