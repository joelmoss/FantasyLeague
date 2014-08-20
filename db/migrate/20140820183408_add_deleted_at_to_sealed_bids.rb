class AddDeletedAtToSealedBids < ActiveRecord::Migration
  def change
    add_column :sealed_bids, :deleted_at, :datetime
    add_index :sealed_bids, :deleted_at
  end
end
