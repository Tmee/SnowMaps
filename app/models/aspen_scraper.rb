class AspenScraper < ActiveRecord::Base

  def initialize
    # set_documents
    # generate_mountain_information
    # generate_peak
    # scrape_for_trails
  end

  def generate_mountain_information
    new_snow = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//ul//li//strong//text()").map {|x| x.to_s.split(' ').join}

    Mountain.create!(name:      "Aspen",
                    last_24:        ,
                    overnight:      ,
                    last_48:        ,
                    last_7_days:    ,
                    base_depth:     ,
                    season_total:   ,
                    acres_open:     ,
                    lifts_open:     ,
                    runs_open:      ,
                    snow_condition: ,
                    town:           ""
    )
  end

  def generate_peak
    peaks = ['Blue Trails', 'Black Trails', 'Double Black Trails']
    peaks.each do |peak|
    Peak.create!(name: peak,
                mountain_id: 8
    )
  end


  private

  def set_documents
    @terrain_doc  = Nokogiri::HTML(open("http://www.aspensnowmass.com/aspen-mountain/grooming"))
    @mountain_doc = Nokogiri::HTML(open("http://www.aspensnowmass.com/aspen-mountain/snow-report-for-aspen-mountain"))
  end
end