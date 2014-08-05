class CreateJoinTableFixturePlayer < ActiveRecord::Migration
  def change
    create_join_table :fixtures, :players do |t|
      t.index [:fixture_id, :player_id]
      t.integer :pld, :gls, :ass, :cs, :ga, :tot
    end
  end
end
