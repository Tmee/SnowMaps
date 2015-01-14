class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string  :name
      t.integer :peak_id
      t.boolean :open,         default: false

      t.timestamps
    end
  end
end
