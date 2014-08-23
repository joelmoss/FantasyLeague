class CreateTeamMonths < ActiveRecord::Migration
  def change
    create_table :team_months do |t|
      t.integer :season, :month, index: true
      t.date :month_beginning
      t.references :team, index: true
      t.integer :gls, :ass, :cs, :ga, :tot
      t.timestamps
    end
  end
end
