class AddStatusToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :status, :string
    add_column :players, :status_notes, :string
  end
end
