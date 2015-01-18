class VailTrails < ActiveRecord::Migration
  def change
    create_table :vail_trails do |t|
      t.string  :name
      t.string  :difficulty
      t.integer :peak_id
      t.integer :mountain_id,  default: 1
      t.integer :open,         default: false

      t.timestamps
    end
  end
end
