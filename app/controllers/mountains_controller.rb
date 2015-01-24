class MountainsController < ApplicationController

  def new
  end

  def create
  end

  def show
    format_time
    @mountain = Mountain.find_by slug: params[:mountain]
    weather_all = @w_api.forecast_for("CO","#{@mountain.town}")['forecast']['simpleforecast']['forecastday']

    weather_day_1  = weather_all[0]
    weather_day_2  = weather_all[1]
    weather_day_3  = weather_all[2]



    weather = []
    weather << weather_day_1
    weather << weather_day_2
    weather << weather_day_3

    @day_1 = weather[0]
    @day_2 = weather[1]
    @day_3 = weather[2]


    @day_1_icon = weather[0]['icon_url']
    @day_2_icon = weather[1]['icon_url']
    @day_3_icon = weather[2]['icon_url']
  end
end
