class CreateTellurideScrapers < ActiveRecord::Migration
  def change
    create_table :telluride_scrapers do |t|

      t.timestamps
    end
  end
end
