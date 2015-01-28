class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :format_time
  helper_method :current_user
  helper_method :set_mountains


  def format_time
    raw_time = Time.now
    @time = raw_time.strftime'%I:%M'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_mountains
    @mountains = Mountain.all.order('name ASC')
  end

  protected
end
