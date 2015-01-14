class MountainsController < ApplicationController

  def new
  end

  def create
    @mountain = Mountains.create!(:name)

    if @mountain.save
      flash[:notice] = "mountain created"
      redirect_to root_path
    else
      flash[:notice] = "mountain could not be created"
      render :new
    end
  end

  def show
    format_time
    @mountain = Mountains.find_by name: params[:mountain].capitalize
  end
end
