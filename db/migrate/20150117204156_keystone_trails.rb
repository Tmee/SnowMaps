class KeystoneTrails < ActiveRecord::Migration
  def change
    create_table :keystone_trails do |t|
      t.string  :name
      t.string  :difficulty
      t.integer :peak_id
      t.integer :mountain_id,  default: 4
      t.string  :open

      t.timestamps
    end
  end
end
