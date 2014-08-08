class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name, limit: 64, null: false
      t.string :short_name, limit: 3, null: false
      t.timestamps
    end
  end
end
