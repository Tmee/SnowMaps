class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string  :name
      t.string  :open
      t.integer :peak_id
      t.integer :mountain_id

      t.timestamps
    end
  end
end
