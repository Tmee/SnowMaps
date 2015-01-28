class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :uid
      t.string :provider
      t.string :profile_image_url
      t.string :location

      t.timestamps
    end
  end
end
