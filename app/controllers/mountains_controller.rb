class MountainsController < ApplicationController
  before_action :set_mountains

  def new
  end

  def index
    @mountains = Mountain.all
  end

  def create
  end

  def show
    format_time
    @mountain  = Mountain.find_by slug: params[:mountain].order(asc)
  end
end
