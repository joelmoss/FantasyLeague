class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.references :manager
      t.decimal :budget, precision: 5, scale: 2
      t.index :name, unique: true
      t.timestamps
    end
  end
end
