class MountainsController < ApplicationController

  def new
  end

  def create
    @mountain = Mountain.create!(:name)

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
    if params[:search].present?
      @mountain = Mountain.all.reject do |mount|
        !mount.name.include? params[:search].capitalize
      end
    else
      @mountain = Mountain.find_by slug: params[:mountain]
    end
  end
end
