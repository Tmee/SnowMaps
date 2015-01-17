class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.create! :name => auth_hash["info"]["name"], :uid => auth_hash[:uid]
    session[:user_id] = user.id
    user.save
    redirect_to today_path
  end

  def destroy
    session.clear
    redirect_to today_path, :notice => "You are logged out."
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
