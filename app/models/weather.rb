class Weather < ActiveRecord::Base

  def initialize
    @w_api = Wunderground.new
    clear_old_reports
    gather_mountain_weather_reports
  end

  def gather_mountain_weather_reports
    get_vail_weather_report
    get_keystone_weather_report
    sleep(35.seconds)
    get_breckenridge_weather_report
    get_beaver_creek_weather_report
    sleep(35.seconds)
    get_a_basin_weather_report
    get_loveland_weather_report
    sleep(35.seconds)
    get_winter_park_weather_report
    get_telluride_weather_report
    sleep(35.seconds)
    get_copper_weather_report
    get_powderhorn_weather_report
  end

  def get_vail_weather_report
    forecast     = get_forecast("Vail")
    current_temp = get_current_temp("Vail")
    create_weather_report(forecast, current_temp, 1)
  end

  def get_keystone_weather_report
    forecast     = get_forecast("Keystone")
    current_temp = get_current_temp("Keystone")
    create_weather_report(forecast, current_temp, 2)
  end

  def get_breckenridge_weather_report
    forecast     = get_forecast("Breckenridge")
    current_temp = get_current_temp("Breckenridge")
    create_weather_report(forecast, current_temp, 3)
  end

  def get_beaver_creek_weather_report
    forecast     = get_forecast("Avon")
    current_temp = get_current_temp("Avon")
    create_weather_report(forecast, current_temp, 4)
  end

  def get_a_basin_weather_report
    forecast     = get_forecast("Keystone")
    current_temp = get_current_temp("Keystone")
    create_weather_report(forecast, current_temp, 5)
  end

  def get_loveland_weather_report
    forecast     = get_forecast("Georgetown")
    current_temp = get_current_temp("Georgetown")
    create_weather_report(forecast, current_temp, 6)
  end

  def get_winter_park_weather_report
    forecast     = get_forecast("Winter Park")
    current_temp = get_current_temp("Winter Park")
    create_weather_report(forecast, current_temp, 7)
  end

  def get_telluride_weather_report
    forecast     = get_forecast("Telluride")
    current_temp = get_current_temp("Telluride")
    create_weather_report(forecast, current_temp, 8)
  end

  def get_powderhorn_weather_report
    forecast     = get_forecast("Mesa")
    current_temp = get_current_temp("Mesa")
    create_weather_report(forecast, current_temp, 9)
  end

  def get_copper_weather_report
    forecast     = get_forecast("Copper Mountain")
    current_temp = get_current_temp("Copper Mountain")
    create_weather_report(forecast, current_temp, 10)
  end

  private

  def get_forecast(town)
    @w_api.forecast_for("CO","#{town}")['forecast']['simpleforecast']['forecastday']
  end

  def get_current_temp(town)
    @w_api.forecast_and_conditions_for("CO","#{town}")['current_observation']['temp_f']
  end

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