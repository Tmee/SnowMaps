class BreckenridgeScraper < ActiveRecord::Base

  def initialize
    set_documents
    create_mountain_information
    generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data

    Mountain.create!(name:   "Breckenridge Resort",
                    last_24:        report[0],
                    overnight:      report[1],
                    last_48:        report[2],
                    last_7_days:    report[3],
                    season_total:   report[4],
                    acres_open:     report[5],
                    lifts_open:     report[6],
                    runs_open:      report[7],
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
    breckenridge_peak_names = ['Peak 7', 'Peak 8', 'Peak 9', 'Peak 10', 'Terrain Parks', 'T-bar', 'Bowls', 'Peak 6']
    breckenridge_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 3
      )
    end
  end

  def scrape_for_trails
    scrape_for_peak_6
    scrape_for_peak_7
    scrape_for_peak_8
    scrape_for_peak_9
    scrape_for_peak_10
    scrape_for_terrain_parks
    scrape_for_t_bar
    scrape_for_bowls
  end

  def scrape_for_peak_7
    peak_7_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")

    format_open_and_difficulty(peak_7_trails)

    peak_7_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 11,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_peak_8
    peak_8_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")

    format_open_and_difficulty(peak_8_trails)

    peak_8_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 12,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_peak_9
    peak_9_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")

    format_open_and_difficulty(peak_9_trails)

    peak_9_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 13,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_peak_10
    peak_10_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")

    format_open_and_difficulty(peak_10_trails)

    peak_10_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 14,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_terrain_parks
    terrain_park_trails = scrape_raw_html("//div[contains(@id, 'GA9001')]//td//tr")

    format_open_and_difficulty(terrain_park_trails)

    terrain_park_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 15,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_t_bar
    t_bar_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")

    format_open_and_difficulty(t_bar_trails)

    t_bar_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 16,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_bowls
    bowls_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")

    format_open_and_difficulty(bowls_trails)

    bowls_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 17,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_peak_6
    peak_6_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")

    format_open_and_difficulty(peak_6_trails)

    peak_6_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 18,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  private

  def set_documents
    @doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    @mountain_doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/snow-and-weather-report.aspx"))
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
