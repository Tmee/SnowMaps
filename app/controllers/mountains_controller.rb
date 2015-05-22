class MountainsController < ApplicationController
  before_action :set_mountains

  def today
    @mountains = Mountain.all.order(overnight: :asc)
    @most_snow = @mountains[0]
  end

  def index
    @mountains = Mountain.all
  end

  def show
    @mountain  = Mountain.find_by slug: params[:mountain]
  end
end
