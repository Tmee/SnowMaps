class CreateMountains < ActiveRecord::Migration
  def change
    create_table :mountains do |t|
      t.string  :name
      t.string  :slug
      t.string  :last_24
      t.string  :overnight
      t.string  :last_48
      t.string  :last_7_days
      t.string  :acres_open
      t.string  :lifts_open
      t.string  :runs_open
      t.string  :snow_condition
      t.integer :base_depth
      t.integer :season_total

      t.timestamps
    end
  end
end
