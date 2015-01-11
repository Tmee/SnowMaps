class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :modal_new_user

  protect_from_forgery with: :exception



  protected

  def modal_new_user
    @user = User.new
  end
end
