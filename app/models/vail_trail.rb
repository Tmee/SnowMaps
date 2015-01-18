class VailTrail < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA8"))
    scrape_for_vail_village_trails
    scrape_for_back_bowls
    scrape_for_blue_sky_basin
    scrape_for_china_bowl
    scrape_for_golden_peak
    scrape_for_lionshead
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
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',')
    end
  end
end
