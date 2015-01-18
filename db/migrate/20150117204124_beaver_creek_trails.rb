class BeaverCreekTrails < ActiveRecord::Migration
  def change
    create_table :beever_creek_trails do |t|
      t.string  :name
      t.string  :difficulty
      t.integer :peak_id
      t.integer :mountain_id,  default: 6
      t.integer :open,         default: false

      t.timestamps
    end
  end
end
