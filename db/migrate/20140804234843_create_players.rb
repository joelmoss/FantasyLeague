class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :short_name, :full_name, limit: 64, null: false
      t.string :club, limit: 3, null: false
      t.string :position, limit: 1, null: false
      t.string :image, null: false
      t.index :short_name
      t.index :full_name, unique: true
      t.timestamps
    end
  end
end
