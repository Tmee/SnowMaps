class MountainsController < ApplicationController
  before_action :set_mountains

  def today
    @most_snow = Mountain.max_overnight
    @mountains = Mountain.where.not(id: @most_snow.id)
    @all_mountains = Mountain.all
  end

  def index
    @mountains = Mountain.all
  end

  def show
    @mountain  = Mountain.find_by slug: params[:mountain]
  end
end
