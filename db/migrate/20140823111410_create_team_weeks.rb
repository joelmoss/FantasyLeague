class CreateTeamWeeks < ActiveRecord::Migration
  def change
    create_table :team_weeks do |t|
      t.integer :season, :week, index: true
      t.date :week_beginning
      t.references :team, index: true
      t.integer :gls, :ass, :cs, :ga, :tot
      t.timestamps
    end
  end
end
