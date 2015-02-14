class MountainsController < ApplicationController
  before_action :set_mountains

  def today
    format_time
    @mountains = Mountain.all.order(overnight: :desc)
    @most_snow = @mountains[0]
  end

  def index
    @mountains = Mountain.all
  end

  def show
    format_time
    @mountain  = Mountain.find_by slug: params[:mountain]
  end
end
