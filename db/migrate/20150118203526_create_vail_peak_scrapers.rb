class CreateVailPeakScrapers < ActiveRecord::Migration
  def change
    create_table :vail_peak_scrapers do |t|

      t.timestamps
    end
  end
end
