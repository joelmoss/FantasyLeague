class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.string :home_team, :away_team, limit: 32, null: false
      t.integer :home_score, :away_score, null: false
      t.date :date, null: false
      t.time :time, null: false
      t.index [:home_team, :away_team, :date], unique: true
      t.timestamps
    end
  end
end
