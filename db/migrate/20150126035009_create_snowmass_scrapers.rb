class CreateSnowmassScrapers < ActiveRecord::Migration
  def change
    create_table :snowmass_scrapers do |t|

      t.timestamps
    end
  end
end
