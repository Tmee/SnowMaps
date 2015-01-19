class CreateVailTrailScrapers < ActiveRecord::Migration
  def change
    create_table :vail_trail_scrapers do |t|

      t.timestamps
    end
  end
end
