class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :format_time
  helper_method :current_user
  before_action :set_weather_api

  def set_weather_api
    @w_api = Wunderground.new
  end

  def format_time
    raw_time = Time.now
    @time = raw_time.strftime'%I:%M'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  protected
end
