class CreateKeystoneScrapers < ActiveRecord::Migration
  def change
    create_table :keystone_scrapers do |t|

      t.timestamps
    end
  end
end
