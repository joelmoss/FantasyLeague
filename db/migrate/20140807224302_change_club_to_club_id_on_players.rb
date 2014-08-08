class ChangeClubToClubIdOnPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :club
    add_reference :players, :club, index: true
  end
end
