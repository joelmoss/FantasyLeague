class ChangeFixtures < ActiveRecord::Migration
  def change
    drop_table :fixtures

    create_table :fixtures do |t|
      t.references :home_club, :away_club, null: false, index: true
      t.integer :home_score, :away_score
      t.date :date, null: false
      t.time :time, null: false
      t.index [:home_club_id, :away_club_id, :date], unique: true
      t.timestamps
    end
  end
end
