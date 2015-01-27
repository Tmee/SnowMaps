class CreatePowderhornScrapers < ActiveRecord::Migration
  def change
    create_table :powderhorn_scrapers do |t|

      t.timestamps
    end
  end
end
