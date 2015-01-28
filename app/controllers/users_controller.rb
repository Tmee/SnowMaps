  class UsersController < ApplicationController

  def today
    format_time
    @mountains = Mountain.all.order(overnight: :desc)
    @most_snow = @mountains[0]
  end

  def create
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def index
  end
end
