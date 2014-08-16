class AddDeletedAtToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :deleted_at, :datetime
    add_index :conversations, :deleted_at
  end
end
