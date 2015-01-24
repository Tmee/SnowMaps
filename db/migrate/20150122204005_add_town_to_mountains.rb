class AddTownToMountains < ActiveRecord::Migration
  def change
    add_column :mountains, :town, :string
  end
end
