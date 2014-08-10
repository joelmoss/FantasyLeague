class TeamPlayer < ActiveRecord::Base

  belongs_to :player
  belongs_to :team

  delegate :full_position, :position, :club, :seasons, :to_s, :short_name, to: :player

  validates :team_id, presence: true
  validates :purchase_price, presence: true

  after_create :recalculate_team_budget


  private

    # TODO: warn when recalculated budget goes below zero
    def recalculate_team_budget
      team.update_attribute :budget, team.budget - purchase_price
    end

end
