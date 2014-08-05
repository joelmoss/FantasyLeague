class CreateSquads < ActiveRecord::Migration
  def change
    create_table :squads do |t|
      t.boolean :substitute, default: true, null: false
      t.decimal :purchase_price, precision: 5, scale: 2
      t.references :player, :team
      t.index [:player_id, :team_id]
      t.timestamps
    end
  end
end
