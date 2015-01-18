class VailTrail < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA8"))
    @weather_doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/snow-and-weather-report.aspx"))
    scrape_for_trails
  end

  def scrape_for_trails
    scrape_for_vail_village_trails
    scrape_for_back_bowls
    scrape_for_blue_sky_basin
    scrape_for_china_bowl
    scrape_for_golden_peak
    scrape_for_lionshead
  end

  def scrape_for_mountain_information
    new_snow = @weather_doc.xpath("//div[contains(@class, 'newSnow')]//tr//td[position() = 2]//text()").text.scan(/\b(\d)\b/)

    snow_conditions =  @weather_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s/, "")

    snow_stats_raw = @weather_doc.xpath("//div[contains(@class, 'snowConditions')]//tr//td//span//text()").to_a
    snow_stats = snow_stats.map do |snow|
        snow.text.gsub(/\s/, "")
      end

    terrain_report_raw = @weather_doc.xpath("//div[contains(@class, 'terrain')]//tr//td[position() = 2]//text()").to_a
    terrain_report = terrain_report_raw.map do |terrain|
      terrain.text.gsub(/\s/, "")
    end


    snow_info.each do |trail|
      Mountain.create!(name:       trail[:name],
                      last_24:     trail[:last_24],
                      overnight:   trail[:overnight],
                      last_48:     trail[:last_48],
                      last_7_days: trail[:last_7_days],
                      acres_open:  trail[:acres_open],
                      acres_total: trail[:acres_total],
      )
    end
  end

  def scrape_for_vail_village_trails
    vail_village_trails = scrape_raw_html("//div[contains(@id, 'GA8')]//td//tr")

    format_open_and_difficulty(vail_village_trails)

    vail_village_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 1,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_back_bowls
    back_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")

    format_open_and_difficulty(back_bowl_trails)

    back_bowl_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 2,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_blue_sky_basin
    blue_sky_basin_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")

    format_open_and_difficulty(blue_sky_basin_trails)

    blue_sky_basin_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 3,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_china_bowl
    china_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")

    format_open_and_difficulty(china_bowl_trails)

    china_bowl_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 4,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_golden_peak

    golden_peak_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")

    format_open_and_difficulty(golden_peak_trails)

    golden_peak_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 5,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_lionshead
    lionshead_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")

    format_open_and_difficulty(lionshead_trails)

    lionshead_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 6,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  protected

  def scrape_raw_html(xpath)
    rows = @doc.xpath(xpath)
    trails_array = rows.collect do |row|
    detail = {}
    [
      [:name, 'td[position() = 2]//text()'],
      [:open, 'td[position() = 3]'],
      [:difficulty, 'td[position() = 1]'],
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
      end
    detail
    end
  end

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open] = trail[:open].scan(/\b(noStatus|yesStatus)\b/).join(',')
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult|doubleDiamond)\b/).join(',')
    end
  end
end
