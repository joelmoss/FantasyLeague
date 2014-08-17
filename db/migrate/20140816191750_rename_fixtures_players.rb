class RenameFixturesPlayers < ActiveRecord::Migration
  def change
    drop_table :fixtures_players

    create_table :fixture_players do |t|
      t.references :fixture, :player, index: true
      t.integer :pld, :gls, :ass, :cs, :ga, :tot
      t.boolean :red_card, :yellow_card, :full_game, :subbed_off, :subbed_on
    end
  end
end
