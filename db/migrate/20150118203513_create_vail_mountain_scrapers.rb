class CreateVailMountainScrapers < ActiveRecord::Migration
  def change
    create_table :vail_mountain_scrapers do |t|

      t.timestamps
    end
  end
end
