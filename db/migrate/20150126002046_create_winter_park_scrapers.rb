class CreateWinterParkScrapers < ActiveRecord::Migration
  def change
    create_table :winter_park_scrapers do |t|

      t.timestamps
    end
  end
end
