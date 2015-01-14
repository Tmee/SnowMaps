class CreateMountains < ActiveRecord::Migration
  def change
    create_table :mountains do |t|
      t.string  :name
      t.string  :slug
      t.integer :last_two_four
      t.integer :overnight
      t.integer :last_four_eight
      t.integer :last_seven_days
      t.integer :acres_open
      t.integer :acres_total
      t.integer :lifts_open
      t.integer :lifts_total
      t.integer :runs_open
      t.integer :runs_total
      t.string  :snow_condition
      t.integer :base_depth
      t.integer :season_total

      t.timestamps
    end
  end
end
