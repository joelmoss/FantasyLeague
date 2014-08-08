class ChangePositionOnPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :position
    add_column :players, :position, :integer, limit: 1
  end
end
