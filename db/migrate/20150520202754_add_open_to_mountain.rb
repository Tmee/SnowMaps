class AddOpenToMountain < ActiveRecord::Migration
  def change
    add_column :mountains, :open, :boolean
  end
end
