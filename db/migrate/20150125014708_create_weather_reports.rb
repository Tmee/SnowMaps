class CreateWeatherReports < ActiveRecord::Migration
  def change
    create_table :weather_reports do |t|
      t.string  :weekday
      t.string  :icon
      t.text    :conditions
      t.integer :mountain_id
      t.string  :high
      t.string  :low
      t.string  :current_temp

      t.timestamps
    end
  end
end
