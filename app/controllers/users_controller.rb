class UsersController < ApplicationController

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)

    if @user.save
      session[:email] = @user.id
      flash[:notice] = "User created"
      redirect_to root_path
    else
      flash[:notice] = "User could not be created"
      render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
