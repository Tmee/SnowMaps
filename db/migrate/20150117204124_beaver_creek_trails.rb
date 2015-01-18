class BeaverCreekTrails < ActiveRecord::Migration
  def change
    create_table :beaver_creek_trails do |t|
      t.string  :name
      t.string  :difficulty
      t.integer :peak_id
      t.integer :mountain_id,  default: 6
      t.string  :open

      t.timestamps
    end
  end
end
