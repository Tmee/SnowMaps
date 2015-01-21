class MountainsController < ApplicationController

  def new
  end

  def create
  end

  def show
    format_time
    @mountain = Mountain.find_by slug: params[:mountain]
  end
end
