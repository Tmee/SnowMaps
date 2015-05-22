class VailScraper

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
    @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//text()").to_s.include?("is closed") ? Mountain.find_by(name: 'Vail Ski Resort').set_closed : Mountain.find_by(name: 'Vail Ski Resort').set_open
  end

  def generate_mountain
    if Mountain.find_by(name: 'Vail Ski Resort').nil?
      Mountain.create!(name: 'Vail Ski Resort')
    end
  end

  def generate_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data

    Mountain.find(9).update(last_24:        report[0],
                            overnight:      report[1],
                            last_48:        report[2],
                            last_7_days:    report[3],
                            base_depth:     report[4],
                            season_total:   report[5],
                            acres_open:     report[6],
                            lifts_open:     report[7],
                            runs_open:      report[8],
                            snow_condition: snow_condition)
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
    if Mountain.find(9).peaks.empty?
      ['Vail Village', 'Back Bowls', 'Blue Sky Basin', 'China Bowl', 'Golden Peak', 'Lionshead'].each do |peak|
        Peak.create!(name: peak, mountain_id: 9)
      end
    end
  end

  def generate_trails
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
    create_trails(vail_village_trails, 44)
  end

  def scrape_for_back_bowls
    back_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")
    format_open_and_difficulty(back_bowl_trails)
    create_trails(back_bowl_trails, 45)
  end

  def scrape_for_blue_sky_basin
    blue_sky_basin_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")
    format_open_and_difficulty(blue_sky_basin_trails)
    create_trails(blue_sky_basin_trails, 46)
  end

  def scrape_for_china_bowl
    china_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")
    format_open_and_difficulty(china_bowl_trails)
    create_trails(china_bowl_trails, 47)
  end

  def scrape_for_golden_peak
    golden_peak_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")
    format_open_and_difficulty(golden_peak_trails)
    create_trails(golden_peak_trails, 48)
  end

  def scrape_for_lionshead
    lionshead_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")
    format_open_and_difficulty(lionshead_trails)
    create_trails(lionshead_trails, 49)
  end

  private

  def set_documents
    @doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA8"))
    @mountain_doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/snow-and-weather-report.aspx"))
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

  def scrape_raw_html(xpath)
    rows = @doc.xpath(xpath)
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
    !Mountain.find_by(name: 'Vail Ski Resort').open?
  end
end
