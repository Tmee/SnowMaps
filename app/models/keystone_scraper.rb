class KeystoneScraper

  def initialize
    set_documents
    generate_mountain
    check_open_status
    unless closed?
      generate_mountain_information
      generate_peak_names
      generate_trails
    end
  end

  def check_open_status
    @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//text()").to_s.include?("is closed") ? Mountain.find_by(name: "Keystone Resort").set_closed : Mountain.find_by(name: "Keystone Resort").set_open
  end

  def generate_mountain
    if Mountain.find_by(name: "Keystone Resort").nil?
      Mountain.create!(name: "Keystone Resort")
    end
  end

  def generate_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data

    Mountain.find(5).update(last_24:        report[0],
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

  def generate_peak_names
    keystone_peak_names = ['Dercum Mountain', 'A51 Terrain Park', 'North Peak', 'Outback']
    keystone_peak_names.each do |peak|
      if Peak.find_by(name: peak).nil?
        Peak.create!(name: peak,
                    mountain_id: 5)
      end
    end
  end

  def generate_trails
    scrape_for_dercum_trails
    scrape_for_a51_trails
    scrape_for_north_peak_trails
    scrape_for_outback_trails
  end

  def scrape_for_dercum_trails
    dercum_trails = scrape_raw_html(1)
    format_open_and_difficulty(dercum_trails)
    create_trails(dercum_trails, 24)
  end

  def scrape_for_a51_trails
    a51_trails = scrape_raw_html(4)
    format_open_and_difficulty(a51_trails)
    create_trails(a51_trails, 25)
  end

  def scrape_for_north_peak_trails
    north_peak_trails = scrape_raw_html(2)
    format_open_and_difficulty(north_peak_trails)
    create_trails(north_peak_trails, 26)
  end

  def scrape_for_outback_trails
    outback_trails = scrape_raw_html(3)
    format_open_and_difficulty(outback_trails)
    create_trails(outback_trails, 27)
  end

  def set_documents
    @doc = Nokogiri::HTML(open("http://www.keystoneresort.com/ski-and-snowboard/terrain-status.aspx#/TerrainStatus"))
    @mountain_doc = Nokogiri::HTML(open("http://www.keystoneresort.com/ski-and-snowboard/snow-report.aspx"))
  end

  def scrape_for_snow_report_data
    snow_report_array = @mountain_doc.xpath("//div[contains(@class, 'snowReportDataColumn2')]//tr//td[position() = 2]")
    snow_report_formatted = snow_report_array.map do |report|
      report.text.gsub(/\s{2}/, "")
    end
    snow_report_formatted.delete_at(6)
    snow_report_formatted.delete('')
    snow_report_formatted
  end

  def scrape_for_snow_condition
    @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s{2}/, "")
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

  def scrape_raw_html(section)
    rows = @doc.xpath("//div[contains(@id, #{section})]//td//tr")
    rows.collect do |row|
      {
        :name => row.xpath("td[position() = 2]//text()").text,
        :open => row.xpath("td[position() = 3]//@class").text,
        :difficulty  => row.xpath("td[position() = 1]//@class").text
      }
    end
  end

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open]       = trail[:open].scan(/\b(noStatus|yesStatus)\b/).join
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult|doubleDiamond)\b/).join
    end
  end

  def closed?
    !Mountain.find_by(name: "Keystone Resort").open?
  end
end