class CreateArapahoeBasinScrapers < ActiveRecord::Migration
  def change
    create_table :arapahoe_basin_scrapers do |t|

      t.timestamps
    end
  end
end
