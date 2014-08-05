class AddNameToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :name, :string, limit: 64
  end
end
