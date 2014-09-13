class AddClubChangedToTeamPlayers < ActiveRecord::Migration
  def change
    add_column :team_players, :club_changed_from, :integer
  end
end
