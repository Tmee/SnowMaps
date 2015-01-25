class Weather < ActiveRecord::Base

  def initialize
    clear_old_reports
    gather_mountain_weather_reports
  end

  def gather_mountain_weather_reports
    @w_api = Wunderground.new
    get_vail_weather_report
    get_keystone_weather_report
    get_breckenridge_weather_report
    get_beaver_creek_weather_report
    get_a_basin_weather_report
    get_loveland_weather_report
  end

  def get_vail_weather_report
    forecast = @w_api.forecast_for("CO","Vail")['forecast']['simpleforecast']['forecastday']
    forecast.each do |day|
      WeatherReport.create!(mountain_id: 1,
                            icon:        day['icon_url'],
                            weekday:     day['date']['weekday'],
                            conditions:  day['conditions'],
                            high:        day['high']['fahrenheit'],
                            low:         day['low']['fahrenheit']
    )
    end
  end

  def get_keystone_weather_report
    forecast = @w_api.forecast_for("CO","Keystone")['forecast']['simpleforecast']['forecastday']
    forecast.each do |day|
      WeatherReport.create!(mountain_id: 2,
                            icon:        day['icon_url'],
                            weekday:     day['date']['weekday'],
                            conditions:  day['conditions'],
                            high:        day['high']['fahrenheit'],
                            low:         day['low']['fahrenheit']
    )
    end
  end

  def get_breckenridge_weather_report
    forecast = @w_api.forecast_for("CO","Breckenridge")['forecast']['simpleforecast']['forecastday']
    forecast.each do |day|
      WeatherReport.create!(mountain_id: 3,
                            icon:        day['icon_url'],
                            weekday:     day['date']['weekday'],
                            conditions:  day['conditions'],
                            high:        day['high']['fahrenheit'],
                            low:         day['low']['fahrenheit']
    )
    end
  end

  def get_beaver_creek_weather_report
    forecast = @w_api.forecast_for("CO","Avon")['forecast']['simpleforecast']['forecastday']
    forecast.each do |day|
      WeatherReport.create!(mountain_id: 4,
                            icon:        day['icon_url'],
                            weekday:     day['date']['weekday'],
                            conditions:  day['conditions'],
                            high:        day['high']['fahrenheit'],
                            low:         day['low']['fahrenheit']
    )
    end
  end

  def get_a_basin_weather_report
    forecast = @w_api.forecast_for("CO","Keystone")['forecast']['simpleforecast']['forecastday']
    forecast.each do |day|
      WeatherReport.create!(mountain_id: 5,
                            icon:        day['icon_url'],
                            weekday:     day['date']['weekday'],
                            conditions:  day['conditions'],
                            high:        day['high']['fahrenheit'],
                            low:         day['low']['fahrenheit']
    )
    end
  end


  def get_loveland_weather_report
    forecast = @w_api.forecast_for("CO","Georgetown")['forecast']['simpleforecast']['forecastday']
    forecast.each do |day|
      WeatherReport.create!(mountain_id: 6,
                            icon:        day['icon_url'],
                            weekday:     day['date']['weekday'],
                            conditions:  day['conditions'],
                            high:        day['high']['fahrenheit'],
                            low:         day['low']['fahrenheit']
    )
    end
  end

  private

  def clear_old_reports
    if WeatherReport.any?
      WeatherReport.destroy_all
    end
  end
end
