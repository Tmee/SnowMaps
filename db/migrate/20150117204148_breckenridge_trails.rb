class BreckenridgeTrails < ActiveRecord::Migration
  def change
    create_table :breckenridge_trails do |t|
      t.string  :name
      t.string  :difficulty
      t.integer :peak_id
      t.integer :mountain_id,  default: 2
      t.string  :open

      t.timestamps
    end
  end
end
