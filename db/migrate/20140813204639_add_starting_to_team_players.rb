class AddStartingToTeamPlayers < ActiveRecord::Migration
  def change
    add_column :team_players, :starting, :boolean, default: false, null: false
    add_index :team_players, :starting
  end
end
