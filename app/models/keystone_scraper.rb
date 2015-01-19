class KeystoneScraper < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.keystoneresort.com/ski-and-snowboard/terrain-status.aspx#/TerrainStatus"))
    @mountain_doc = Nokogiri::HTML(open("http://www.keystoneresort.com/ski-and-snowboard/snow-report.aspx"))
    create_mountain_information
    generate_peak_names
    scrape_for_trails
  end

  def create_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data

    Mountain.create!(name:   "Keystone Resort",
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
    snow_report_formatted.delete_at(6)
    snow_report_formatted.delete('')
    snow_report_formatted
  end

  def scrape_for_snow_condition
    snow_condition =  @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s/, "")
  end

  def generate_peak_names
    keystone_peak_names = ['Dercum Mountain', 'A51 Terrain Park', 'North Peak', 'Outback', 'Lifts']
    keystone_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 2
      )
    end
  end

  def scrape_for_trails
    scrape_for_dercum_trails
    scrape_for_a51_trails
    scrape_for_north_peak_trails
    scrape_for_outback_trails
  end

  def scrape_for_dercum_trails
    dercum_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")

    format_open_and_difficulty(dercum_trails)

    dercum_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 8,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_a51_trails
    a51_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")

    format_open_and_difficulty(a51_trails)

    a51_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_north_peak_trails
    north_peak_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")

    format_open_and_difficulty(north_peak_trails)

    north_peak_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 10,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_outback_trails
    outback_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")

    format_open_and_difficulty(outback_trails)

    outback_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 11,
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