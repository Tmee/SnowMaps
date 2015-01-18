class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string  :name
      t.integer :peak_id
      t.string :open

      t.timestamps
    end
  end
end
