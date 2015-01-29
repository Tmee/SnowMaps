class BeaverCreekScraper < ActiveRecord::Base

  def initialize
    set_documents
    create_mountain_information
    # generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
    snow_condition = scrape_for_snow_condition
    report         = scrape_for_snow_report_data
    open_area      = scrape_for_openness

    Mountain.find(4).update(last_24:        report[0],
                            overnight:      report[1],
                            last_48:        report[2],
                            last_7_days:    report[3],
                            base_depth:     report[4],
                            season_total:   report[5],
                            acres_open:     "#{open_area[4]} of #{open_area[5]}",
                            lifts_open:     "#{open_area[0]} of #{open_area[1]}",
                            runs_open:      "#{open_area[2]} of #{open_area[3]}",
                            snow_condition: snow_condition
    )
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
    snow_condition =  @mountain_doc.xpath("//div[contains(@class, 'snowConditions')]//tr[position() = 2]//td[position() = 1]//text()").to_s.gsub("\r\n", "").gsub(/\s{2}/, "")
  end


  def generate_peaks
    beaver_creek_names = ['Arrowhead', 'Bachelor Gulch', 'Beaver Creek', 'Beaver Creek West', 'Birds of Prey', 'Elkhorn', 'Grouse Mountain', 'Larkspur Bowl', 'Rose Bowl']
    beaver_creek_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 4
      )
    end
  end

  def scrape_for_trails
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
    create_trails(arrowhead_trails, 19)
  end

  def scrape_for_bachelor_gulch
    bachelor_gulch_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")
    format_open_and_difficulty(bachelor_gulch_trails)
    create_trails(bachelor_gulch_trails, 20)
  end

  def scrape_for_beaver_creek
    beaver_creek_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")
    format_open_and_difficulty(beaver_creek_trails)
    create_trails(beaver_creek_trails, 21)
  end

  def scrape_for_beaver_creek_west
    beaver_creek_west_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")
    format_open_and_difficulty(beaver_creek_west_trails)
    create_trails(beaver_creek_west_trails, 22)
  end

  def scrape_for_birds_of_prey
    bird_of_prey_trails = scrape_raw_html("//div[contains(@id, 'GA8')]//td//tr")
    format_open_and_difficulty(bird_of_prey_trails)
    create_trails(bird_of_prey_trails, 23)
  end

  def scrape_for_elkhorn
    elkhorn_trails = scrape_raw_html("//div[contains(@id, 'GA9')]//td//tr")
    format_open_and_difficulty(elkhorn_trails)
    create_trails(elkhorn_trails, 24)
  end

  def scrape_for_grouse_mountain
    grouse_mountain_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")
    format_open_and_difficulty(grouse_mountain_trails)
    create_trails(grouse_mountain_trails, 25)
  end

  def scrape_for_larkspur_bowl
    larkspur_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")
    format_open_and_difficulty(larkspur_bowl_trails)
    create_trails(larkspur_bowl_trails, 26)
  end

  def scrape_for_rose_bowl
    rose_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")
    format_open_and_difficulty(rose_bowl_trails)
    create_trails(rose_bowl_trails, 27)
  end

  private


  def set_documents
    @doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    @mountain_doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/snow-report.aspx"))
  end

  def create_trails(trails, peak_id)
    trails.each do |trail|
      unless trail[:name] == ''
        Trail.find_by(name: trail[:name]).update(open: trail[:open],
                                                 difficulty: trail[:difficulty]
        )
      end
    end
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
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult|doubleDiamond|expert)\b/).join(',')
    end
  end
end