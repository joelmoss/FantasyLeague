class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.references :manager
      t.integer :budget
      t.index :name, unique: true
      t.timestamps
    end
  end
end
