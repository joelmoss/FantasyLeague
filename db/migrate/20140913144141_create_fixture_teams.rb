class CreateFixtureTeams < ActiveRecord::Migration
  def change
    create_table :fixture_teams do |t|
      t.references :fixture, :team, index: true
      t.integer :pld, :gls, :ass, :cs, :ga, :tot, default: 0
      t.timestamps
    end
  end
end
