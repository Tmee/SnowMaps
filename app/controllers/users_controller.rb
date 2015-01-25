  class UsersController < ApplicationController

  def today
    format_time
    @mountains = Mountain.all.order(overnight: :desc)
    @most_snow = @mountains[0]
  end

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.create!(user_params)

    if @user.save
      session[:uid] = @user.id
      flash[:notice] = "User created"
      redirect_to root_path
    else
      flash[:notice] = "User could not be created"
      render :new
    end
  end


  protected

  def user_params
    params.require(:user).permit(:uid, :name)
  end
end
