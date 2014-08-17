class CreateTeamSheets < ActiveRecord::Migration
  def change
    create_table :team_sheets do |t|
      t.references :player, :team, index: true
      t.date :date

      t.timestamps
    end
  end
end
