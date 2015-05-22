class BreckenridgeScraper

  def initialize
    set_documents
    generate_mountain
    check_open_status
    unless closed?
      generate_mountain_information
      generate_peaks
      generate_trails
    end
  end

  def check_open_status
    scrape_for_snow_condition.include?('closed') ? Mountain.find_by(name: "Breckenridge").set_closed : Mountain.find_by(name: "Breckenridge").set_open
  end

  def generate_mountain
    if Mountain.find_by(name: "Breckenridge").nil?
      Mountain.create!(name: "Breckenridge")
    end
  end

  def generate_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data

    Mountain.find(3).update(last_24:        report[0],
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
      report.text.gsub(/\s{2}/, "")
    end
    snow_report_formatted.delete('')
    snow_report_formatted
  end

  def scrape_for_snow_condition
    snow_condition =  @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s{2}/, "")
  end

  def generate_peaks
    breckenridge_peak_names = ['Peak 6', 'Peak 7', 'Peak 8', 'Peak 9', 'Peak 10', 'Terrain Parks', 'T-bar', 'Bowls']
    breckenridge_peak_names.each do |peak|
      if Peak.find_by(name: peak).nil?
        Peak.create!(name: peak,
                     mountain_id: 3)
      end
    end
  end

  def generate_trails
    scrape_for_peak_6
    scrape_for_peak_7
    scrape_for_peak_8
    scrape_for_peak_9
    scrape_for_peak_10
    scrape_for_terrain_parks
    scrape_for_t_bar
    scrape_for_bowls
  end

  def scrape_for_peak_6
    peak_6_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")
    format_open_and_difficulty(peak_6_trails)
    create_trails(peak_6_trails, 11)
  end

  def scrape_for_peak_7
    peak_7_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")
    format_open_and_difficulty(peak_7_trails)
    create_trails(peak_7_trails, 12)
  end

  def scrape_for_peak_8
    peak_8_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")
    format_open_and_difficulty(peak_8_trails)
    create_trails(peak_8_trails, 13)
  end

  def scrape_for_peak_9
    peak_9_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")
    format_open_and_difficulty(peak_9_trails)
    create_trails(peak_9_trails, 14)
  end

  def scrape_for_peak_10
    peak_10_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")
    format_open_and_difficulty(peak_10_trails)
    create_trails(peak_10_trails, 15)
  end

  def scrape_for_terrain_parks
    terrain_park_trails = scrape_raw_html("//div[contains(@id, 'GA9001')]//td//tr")
    format_open_and_difficulty(terrain_park_trails)
    create_trails(terrain_park_trails, 16)
  end

  def scrape_for_t_bar
    t_bar_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")
    format_open_and_difficulty(t_bar_trails)
    create_trails(t_bar_trails, 17)
  end

  def scrape_for_bowls
    bowls_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")
    format_open_and_difficulty(bowls_trails)
    create_trails(bowls_trails, 18)
  end


  private

  def set_documents
    @doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    @mountain_doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/snow-and-weather-report.aspx"))
  end

  def create_trails(trails, peak_id)
    trails.each do |trail|
      unless trail[:name] == ''
        if Trail.find_by(name: trail[:name]).nil?
          Trail.create!(name: trail[:name],
                        open: trail[:open],
                        difficulty: trail[:difficulty],
                        peak_id: peak_id)
        else
          Trail.find_by(name: trail[:name]).update_attributes(open: trail[:open])
        end
      end
    end
  end

  def scrape_raw_html(row_xpath)
    rows = @doc.xpath(row_xpath)
    rows.collect do |row|
      {
        :name => row.xpath("td[position() = 2]").text,
        :open => row.xpath("td[position() = 3]//@class").text,
        :difficulty => row.xpath("td[position() = 1]//@class").text
      }
    end
  end

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open] = trail[:open].scan(/\b(noStatus|yesStatus)\b/).join
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult|doubleDiamond)\b/).join
    end
  end

  def closed?
    !Mountain.find_by(name: "Breckenridge").open?
  end
end
