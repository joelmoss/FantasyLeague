class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :subject
      t.references :recipient, index: true
      t.references :creator, index: true

      t.timestamps
    end
  end
end
