class CreateSealedBids < ActiveRecord::Migration
  def change
    create_table :sealed_bids do |t|
      t.references :player, index: true
      t.references :manager, index: true
      t.decimal :bid, precision: 5, scale: 2

      t.timestamps
    end
  end
end
