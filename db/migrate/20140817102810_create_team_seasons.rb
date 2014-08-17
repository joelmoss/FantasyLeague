class CreateTeamSeasons < ActiveRecord::Migration
  def change
    create_table :team_seasons do |t|
      t.integer :season
      t.references :team, index: true
      t.integer :gls, :ass, :cs, :ga, :tot, :red_cards, :yellow_cards

      t.timestamps
    end
    add_index :team_seasons, :season
  end
end
