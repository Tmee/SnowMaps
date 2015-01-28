class SessionsController < ApplicationController

  def create
    user = User.find_or_create_by_auth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to user_path(current_user), notice: "Logged in as #{user.name}"
  end

  def destroy
    session.clear
    redirect_to root_path, notice: "You are logged out."
  end
end
