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
  has_one :team_player, validate: true, dependent: :destroy
  has_one :team, through: :team_player
  has_many :watches, dependent: :destroy
  has_many :watchers, through: :watches, source: :manager
  belongs_to :club
  has_many :fixture_players
  has_many :fixtures, through: :fixture_players
  has_many :sealed_bids, dependent: :destroy

  after_update :notify_status_changes
  before_destroy :notify_manager_of_removal

  accepts_nested_attributes_for :team_player, :sealed_bids

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

  def transfer_listed?
    team_player.try(:transfer_listed?)
  end


  private

    def notify_manager_of_removal
      unless free_agent?
        body = "Sorry to tell you that #{self} has been removed from the player "+
               "list, and therefore has also been removed from your Team with "+
               "immediate effect. Any previous points that he gained you in the "+
               "past will remain in place."
        create_conversation "#{self} removed", body
      end
    end

    def notify_status_changes
      if !free_agent?
        subject = "#{self} status changed"
        if !status_changed? && status_notes_changed?
          if status_notes_was.nil?
            body = "The status of #{self}, which is #{status} has been updated with a note: #{status_notes}"
          elsif status_notes
            body = "The status of #{self}, which is #{status} has been updated from #{status_notes_was} to #{status_notes}"
          end
          create_conversation subject, body
        elsif status_changed?
          if status_was.nil?
            body = "The status of #{self} has changed to #{status}"
          elsif status.nil?
            body = "The status of #{self} has been cleared from #{status_was}. The player is now able to play."
          else
            body = "The status of #{self} has changed from #{status_was} to #{status}"
          end
          body += " (#{status_notes})" if status_notes
          create_conversation subject, body
        end
      end
    end

    def create_conversation(subject, body)
      manager = TeamPlayer.unscoped { team_player }.team.manager
      con = Conversation.create subject: subject, creator: manager, recipient: manager
      con.messages.create manager: manager, body: body
    end

end
