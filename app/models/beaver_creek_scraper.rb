class BeaverCreekScraper

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
    scrape_for_snow_condition.include?('closed') ? Mountain.find(2).set_closed : Mountain.find(2).set_open
  end

  def generate_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data
    open_area      = scrape_for_openness

    Mountain.find(2).update(last_24:        report[0],
                            overnight:      report[1],
                            last_48:        report[2],
                            last_7_days:    report[3],
                            base_depth:     report[4],
                            season_total:   report[5],
                            acres_open:     "#{open_area[4]} of #{open_area[5]}",
                            lifts_open:     "#{open_area[0]} of #{open_area[1]}",
                            runs_open:      "#{open_area[2]} of #{open_area[3]}",
                            snow_condition: snow_condition)
  end

  def scrape_for_openness
    open_area = @doc.xpath("//div[contains(@class, 'gradBorderModule')]//li//span//text()")
    open_area_array = open_area.map do |report|
      report.text.gsub(/\s{2}/, "")
    end
    open_area_array.pop
    open_area_array
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
    @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s{2}/, "")
  end


  def generate_peaks
    beaver_creek_names = ['Arrowhead', 'Bachelor Gulch', 'Beaver Creek', 'Beaver Creek West', 'Birds of Prey', 'Elkhorn', 'Grouse Mountain', 'Larkspur Bowl', 'Rose Bowl']
    beaver_creek_names.each do |peak|
      if Peak.find_by(name: peak).nil?
        Peak.create!(name: peak,
                     mountain_id: 2)
      end
    end
  end

  def generate_trails
    scrape_for_arrowhead
    scrape_for_bachelor_gulch
    scrape_for_beaver_creek
    scrape_for_beaver_creek_west
    scrape_for_birds_of_prey
    scrape_for_elkhorn
    scrape_for_grouse_mountain
    scrape_for_larkspur_bowl
    scrape_for_rose_bowl
  end

  def scrape_for_arrowhead
    arrowhead_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")
    format_open_and_difficulty(arrowhead_trails)
    create_trails(arrowhead_trails, 2)
  end

  def scrape_for_bachelor_gulch
    bachelor_gulch_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")
    format_open_and_difficulty(bachelor_gulch_trails)
    create_trails(bachelor_gulch_trails, 3)
  end

  def scrape_for_beaver_creek
    beaver_creek_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")
    format_open_and_difficulty(beaver_creek_trails)
    create_trails(beaver_creek_trails, 4)
  end

  def scrape_for_beaver_creek_west
    beaver_creek_west_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")
    format_open_and_difficulty(beaver_creek_west_trails)
    create_trails(beaver_creek_west_trails, 5)
  end

  def scrape_for_birds_of_prey
    bird_of_prey_trails = scrape_raw_html("//div[contains(@id, 'GA8')]//td//tr")
    format_open_and_difficulty(bird_of_prey_trails)
    create_trails(bird_of_prey_trails, 6)
  end

  def scrape_for_elkhorn
    elkhorn_trails = scrape_raw_html("//div[contains(@id, 'GA9')]//td//tr")
    format_open_and_difficulty(elkhorn_trails)
    create_trails(elkhorn_trails, 7)
  end

  def scrape_for_grouse_mountain
    grouse_mountain_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")
    format_open_and_difficulty(grouse_mountain_trails)
    create_trails(grouse_mountain_trails, 8)
  end

  def scrape_for_larkspur_bowl
    larkspur_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")
    format_open_and_difficulty(larkspur_bowl_trails)
    create_trails(larkspur_bowl_trails, 9)
  end

  def scrape_for_rose_bowl
    rose_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")
    format_open_and_difficulty(rose_bowl_trails)
    create_trails(rose_bowl_trails, 10)
  end

  def set_documents
    @doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    @mountain_doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/snow-report.aspx"))
  end

  def generate_mountain
    if Mountain.find_by(name: 'Beaver Creek').nil?
      Mountain.create!(name: 'Beaver Creek')
    end
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
        :name => row.xpath("td[position() = 2]//text()").text,
        :open => row.xpath("td[position() = 3]//@class").text,
        :difficulty => row.xpath("td[position() = 1]//@class").text
      }
    end
  end

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open] = trail[:open].scan(/\b(noStatus|yesStatus)\b/).join
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult|doubleDiamond|expert)\b/).join
    end
  end

  def closed?
    !Mountain.find(2).open?
  end
end