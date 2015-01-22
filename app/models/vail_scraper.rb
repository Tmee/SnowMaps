class VailScraper < ActiveRecord::Base

  def initialize
    set_documents
    create_mountain_information
    generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data

    Mountain.create!(name:      "Vail Resort",
                    last_24:        report[0],
                    overnight:      report[1],
                    last_48:        report[2],
                    last_7_days:    report[3],
                    base_depth:     report[4],
                    season_total:   report[5],
                    acres_open:     report[6],
                    lifts_open:     report[7],
                    runs_open:      report[8],
                    snow_condition: snow_condition
    )
  end

  def scrape_for_snow_report_data
    snow_report_array = @mountain_doc.xpath("//div[contains(@class, 'snowReportDataColumn2')]//tr//td[position() = 2]")
    snow_report_formatted = snow_report_array.map do |report|
      report.text.gsub(/\s/, "")
    end
    snow_report_formatted.delete('')
    snow_report_formatted
  end

  def scrape_for_snow_condition
    snow_condition =  @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s/, "")
  end

  def generate_peaks
    vail_peak_names = ['Vail Village', 'Back Bowls', 'Blue Sky Basin', 'China Bowl', 'Golden Peak', 'Lionshead']
    vail_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 1
      )
    end
  end

  def scrape_for_trails
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

  private

  def set_documents
    @doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA8"))
    @mountain_doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/snow-and-weather-report.aspx"))
  end

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
