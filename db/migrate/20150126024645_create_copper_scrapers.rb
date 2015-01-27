class CreateCopperScrapers < ActiveRecord::Migration
  def change
    create_table :copper_scrapers do |t|

      t.timestamps
    end
  end
end
