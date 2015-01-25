class WeatherReport < ActiveRecord::Base
  belongs_to :mountain

  validates :mountain_id, :presence => true
end
