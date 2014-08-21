class AddManagerToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :manager, index: true
  end
end
