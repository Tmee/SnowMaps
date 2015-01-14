class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :privder
      t.string :uid
      t.integer :user_id

      t.timestamps
    end
  end
end
