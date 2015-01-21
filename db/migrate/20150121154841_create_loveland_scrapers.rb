class CreateLovelandScrapers < ActiveRecord::Migration
  def change
    create_table :loveland_scrapers do |t|

      t.timestamps
    end
  end
end
