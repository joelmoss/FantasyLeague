class AddIsNewToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :is_new, :boolean, default: false, null: false
  end
end
