class BreckenridgeScrapers < ActiveRecord::Migration
  def change
    create_table :breckenridge_scrapers do |t|
      t.string  :name
      t.string  :difficulty
      t.integer :peak_id
      t.integer :mountain_id
      t.string  :open

      t.timestamps
    end
  end
end
