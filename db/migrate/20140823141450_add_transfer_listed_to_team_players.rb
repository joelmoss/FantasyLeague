class AddTransferListedToTeamPlayers < ActiveRecord::Migration
  def change
    add_column :team_players, :transfer_listed, :boolean, index: true, default: false
  end
end
