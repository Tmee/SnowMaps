class CreateAspenScrapers < ActiveRecord::Migration
  def change
    create_table :aspen_scrapers do |t|

      t.timestamps
    end
  end
end
