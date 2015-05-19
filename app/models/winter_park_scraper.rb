class WinterParkScraper

  def initialize
    set_documents
    generate_mountain_information
    # generate_peaks
    scrape_for_trails
  end

  def generate_mountain_information
    snow_report        = find_snow_report
    lift_trail_acre    = find_lift_trail_acre
    base_and_condition = find_base_and_condition

    Mountain.find(7).update(last_24:        "#{snow_report[0]} \"",
                            overnight:      "#{snow_report[0]} \"",
                            last_48:        "#{snow_report[1]} \"",
                            season_total:   "#{snow_report[3]} \"",
                            last_7_days:    "-",
                            base_depth:     "#{base_and_condition[0]} \"",
                            snow_condition: base_and_condition[1],
                            lifts_open:     lift_trail_acre[0],
                            runs_open:      lift_trail_acre[1],
                            acres_open:     lift_trail_acre[2]
    )
  end

  def generate_peaks
    peaks = ['Winter Park', 'Mary Jane', 'Vasquez Ridge', 'Parsenn Bowl', 'Eagle Wind', 'The Cirque']

    peaks.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 7
      )
    end
  end

  def scrape_for_trails
    scrape_for_winter_park
    scrape_for_mary_jane
    scrape_for_vasquez_ridge
    scrape_for_parsenn_bowl
    scrape_for_eagle_wind
    scrape_for_the_cirque
  end

  def scrape_for_winter_park
    winter_park_trails = scrape_raw_html(1)
    format_trails(winter_park_trails)
    create_trails(winter_park_trails, 38)
  end

  def scrape_for_mary_jane
    mary_jane_trails = scrape_raw_html(2)
    format_trails(mary_jane_trails)
    create_trails(mary_jane_trails, 39)
  end

  def scrape_for_vasquez_ridge
    vasquez_ridge_trails = scrape_raw_html(3)
    format_trails(vasquez_ridge_trails)
    create_trails(vasquez_ridge_trails, 40)
  end

  def scrape_for_parsenn_bowl
    parsenn_bowl_trails = scrape_raw_html(4)
    format_trails(parsenn_bowl_trails)
    create_trails(parsenn_bowl_trails, 41)
  end

  def scrape_for_eagle_wind
    eagle_wind_trails = scrape_raw_html(5)
    format_trails(eagle_wind_trails)
    create_trails(eagle_wind_trails, 42)
  end

  def scrape_for_the_cirque
    the_cirque_trails = scrape_raw_html(6)
    format_trails(the_cirque_trails)
    create_trails(the_cirque_trails, 43)
  end


private

  def set_documents
    @terrain_doc  = Nokogiri::HTML(open("http://www.winterparkresort.com/the-mountain/lift-and-trail-report.aspx"))
    @mountain_doc = Nokogiri::HTML(open("http://www.winterparkresort.com/the-mountain/snow-weather-report.aspx"))
  end

  def create_trails(trails, peak_id)
    trails.each do |trail|
      if Trail.find_by(name: trail[:name]) == nil
        Trail.create!(peak_id: peak_id,
                      name: trail[:name],
                      open: trail[:open],
                      difficulty: trail[:difficulty]
        )
      else
        Trail.find_by(name: trail[:name]).update(open: trail[:open],
                                                difficulty: trail[:difficulty],
                                                peak_id: peak_id
        )
      end
    end
  end

  def format_trails(trails)
    trails.delete_at(0)
    trails.each do |trail|
      trail[:name] = trail[:name].text
      trail[:open] = trail[:open].text
      trail[:difficulty] = trail[:difficulty].attribute('src').value
    end
    set_the_difficulty(trails)
  end

  def set_the_difficulty(trails)
    trails.each do |trail|
      case trail[:difficulty]
      when 'http://www.winterparkresort.com/~/media/e1a39a124dd04adc8651bb5d73a43f5e.gif?h=12&w=12'
        trail[:difficulty] = 'easy'
      when'http://www.winterparkresort.com/~/media/18a6d892d41c4da9bb92caf301354f4a.gif?h=12&w=12'
        trail[:difficulty] = 'intermediate'
      when'http://www.winterparkresort.com/~/media/d7f8b12d58cd4933853efe65874094c5.gif?h=12&w=12'
        trail[:difficulty] = 'intermediate'
      when 'http://www.winterparkresort.com/~/media/98fc9271e4154ec6ab2c0d634552b904.gif?h=12&w=12'
        trail[:difficulty] = 'advanced'
      when 'http://www.winterparkresort.com/~/media/411eb7f0ae444643a4ad3fd96e206d37.gif?h=12&w=12'
        trail[:difficulty] = 'double diamound'
      end
    end
  end

  def scrape_raw_html(section)
    rows = @terrain_doc.xpath("//div[contains(@id, 'trails2Tab')]//div[contains(@id, 'statusTablesTrail')]//section[position() = #{section}]//tr")
    trails_array = rows.collect do |row|
    detail = {}
    [
      [:name, 'td[position() = 2]'],
      [:open, 'td[position() = 4]'],
      [:difficulty, 'td[position() = 1]//img'],
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath)
      end
    detail
    end
  end

  def find_snow_report
    data = @mountain_doc.xpath("//div[contains(@class, 'conditionBlock')]//span[contains(@class, 'amountNumber')]")
    data.map do |data|
      data.child.attribute('data-imperial').value
    end
  end

  def find_base_and_condition
    base_and_condition = []
    data = @mountain_doc.xpath("//div[contains(@class, 'col snowMeta')]//span[contains(@class, 'data')]").children[0..1]
    base_and_condition << data[0].attribute('data-imperial').value
    base_and_condition << data[1].text
  end

  def find_lift_trail_acre
    lift_trail_acres = @mountain_doc.xpath("//div[contains(@class, 'cols')]//div[contains(@class, 'col snowMeta')]//span[contains(@class, 'data')]").children
    lift_trail_acre = []
    lift_trail_acre << lift_trail_acres[2].text
    lift_trail_acre << lift_trail_acres[3].text
    lift_trail_acre << lift_trail_acres[4].attribute('data-imperial').value
  end
end