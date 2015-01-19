class SearchController < ApplicationController

  def user_search
    @mountains = mountain_search(params[:search].capitalize)
    @peaks = peak_search(params[:search])
    @trails = trail_search(params[:search])
    render :user_search
  end

private

  def mountain_search(search)
    if search
      mountains = Mountain.where('name ILIKE ?', "%#{search}%")
    else
      Mountain.find(:all)
    end
    mountains
  end

  def peak_search(search)
    if search
      peaks = Peak.where('name ILIKE ?', "%#{search}%")
    else
      "nothing, man"
    end
    peaks
  end

  def trail_search(search)
    if search
      trails = Trail.where('name ILIKE ?', "%#{search}%")
    else
      "nothing, man"
    end
    trails
  end
end