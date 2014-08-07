class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.references :player, :manager
      t.timestamps
    end
  end
end
