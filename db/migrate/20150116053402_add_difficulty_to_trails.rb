class AddDifficultyToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :difficulty, :string
  end
end
