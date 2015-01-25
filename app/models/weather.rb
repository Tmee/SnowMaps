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
    current_temp = @w_api.forecast_and_conditions_for("CO","Vail")['current_observation']['temp_f']
    create_weather_report(forecast, current_temp, 1)
  end

  def get_keystone_weather_report
    forecast = @w_api.forecast_for("CO","Keystone")['forecast']['simpleforecast']['forecastday']
    current_temp = @w_api.forecast_and_conditions_for("CO","Keystone")['current_observation']['temp_f']
    create_weather_report(forecast, current_temp, 2)
  end

  def get_breckenridge_weather_report
    forecast = @w_api.forecast_for("CO","Breckenridge")['forecast']['simpleforecast']['forecastday']
    current_temp = @w_api.forecast_and_conditions_for("CO","Breckenridge")['current_observation']['temp_f']
    create_weather_report(forecast, current_temp, 3)
  end

  def get_beaver_creek_weather_report
    forecast = @w_api.forecast_for("CO","Avon")['forecast']['simpleforecast']['forecastday']
    current_temp = @w_api.forecast_and_conditions_for("CO","Avon")['current_observation']['temp_f']
    create_weather_report(forecast, current_temp, 4)
  end

  def get_a_basin_weather_report
    forecast = @w_api.forecast_for("CO","Keystone")['forecast']['simpleforecast']['forecastday']
    current_temp = @w_api.forecast_and_conditions_for("CO","Keystone")['current_observation']['temp_f']
    create_weather_report(forecast, current_temp, 5)
  end


  def get_loveland_weather_report
    forecast = @w_api.forecast_for("CO","Georgetown")['forecast']['simpleforecast']['forecastday']
    current_temp = @w_api.forecast_and_conditions_for("CO","Georgetown")['current_observation']['temp_f']
    create_weather_report(forecast, current_temp, 6)
  end

  private

  def create_weather_report(forecast, current_temp, id)
    forecast.each do |day|
      WeatherReport.create!(mountain_id:  id,
                            icon:         day['icon_url'],
                            weekday:      day['date']['weekday'],
                            conditions:   day['conditions'],
                            high:         day['high']['fahrenheit'],
                            low:          day['low']['fahrenheit'],
                            current_temp: current_temp
    )
    end
  end

  def clear_old_reports
    if WeatherReport.any?
      WeatherReport.destroy_all
    end
  end
end