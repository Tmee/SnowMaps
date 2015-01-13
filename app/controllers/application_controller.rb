class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :modal_new_user
  helper_method :format_time

  def format_time
    raw_time = Time.now
    @time = raw_time.strftime'%I:%M'
  end

  protected

  def modal_new_user
    @user = User.new
  end
end
