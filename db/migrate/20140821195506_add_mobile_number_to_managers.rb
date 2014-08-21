class AddMobileNumberToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :mobile_number, :string
  end
end
