class CreatePlayerSeasons < ActiveRecord::Migration
  def change
    create_table :player_seasons do |t|
      t.integer :season, null: false
      t.references :player, null: false
      t.integer :pld, :gls, :ass, :cs, :ga, :tot, default: 0
      t.index [:season, :player_id], unique: true
      t.timestamps
    end
  end
end
