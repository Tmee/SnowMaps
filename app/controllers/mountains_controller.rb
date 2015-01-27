class MountainsController < ApplicationController

  def new
  end

  def index
    @mountains = Mountain.all
  end

  def create
  end

  def show
    format_time
    @mountain  = Mountain.find_by slug: params[:mountain]
    @mountains = Mountain.all
  end
end
