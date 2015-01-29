class SearchController < ApplicationController

  def user_search
    @mountains ||= mountain_search(params[:search])
    @peaks     ||= peak_search(params[:search])
    @trails    ||= trail_search(params[:search])
    render :user_search
  end

  def mountain_search(search)
    mountains = Mountain.where('name ILIKE ?', "%#{search}%")
  end

  def peak_search(search)
    peaks = Peak.where('name ILIKE ?', "%#{search}%")
  end

  def trail_search(search)
    trails = Trail.where('name ILIKE ?', "%#{search}%")
  end
end