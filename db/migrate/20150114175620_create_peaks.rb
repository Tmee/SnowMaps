class CreatePeaks < ActiveRecord::Migration
  def change
    create_table :peaks do |t|
      t.string  :name
      t.integer :mountain_id

      t.timestamps
    end
  end
end
