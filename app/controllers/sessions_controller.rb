class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.create! :name => auth_hash["info"]["name"], :uid => auth_hash[:uid]
    user.save
    session[:user_id] = user.id

    redirect_to today_path, :notice => "Thanks for using SnowMaps!"
  end

  def destroy
    session.clear
    redirect_to today_path, :notice => "You are logged out."
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end

  def set_user(user)
    @user = user
  end
end
