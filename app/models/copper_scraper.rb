class CopperScraper

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
    if @mountain_doc.xpath("//div[contains(@id, 'report-page')]//table[contains(@class, 'report-page-conditions')][position() = 6]//tr//p").text.include?("We are closed")
      Mountain.find_by(name: "Copper Mountain").set_closed
    else
      Mountain.find_by(name: "Copper Mountain").set_open
    end
  end

  def generate_mountain
    if Mountain.find_by(name: "Copper Mountain").nil?
      Mountain.create!(name: "Copper Mountain")
    end
  end

  def generate_mountain_information
    snow_report    = find_snow_report
    terrain_status = find_terrian_status
    snow_depth     = find_snow_depth

    Mountain.find(4).update(last_24:        "#{snow_report[1]} \"",
                            overnight:      "#{snow_report[8]} \"",
                            last_48:        "#{snow_report[9]} \"",
                            last_7_days:    "#{snow_report[11]} \"",
                            base_depth:     snow_depth,
                            season_total:   "#{snow_report[13]} \"",
                            acres_open:     terrain_status[2],
                            lifts_open:     terrain_status[0],
                            runs_open:      terrain_status[1],
                            snow_condition: terrain_status[3])
  end

  def generate_peaks
    copper_peak_names = ['Beginner', 'Intermediate', 'Advanced', 'Expert', 'Extreme']
    copper_peak_names.each do |peak|
      if Peak.find_by(name: peak).nil?
        Peak.create!(name: peak,
                    mountain_id: 4)
      end
    end
  end

  def generate_trails
    scrape_all_trails
    create_beginner
    create_intermediate
    create_advanced
    create_expert
    create_extreme
  end

  def scrape_all_trails
    trails      = scrape_raw_html("//div//table[contains(@class, 'report-page-status runs')]//tr[position() > 1]")
    @all_trails = format_trails(trails)
  end

  def create_beginner
    trail_set = get_trails('beginner')
    create_trails(trail_set, 19)
  end

  def create_intermediate
    trail_set = get_trails('intermediate')
    create_trails(trail_set, 20)
  end

  def create_advanced
    trail_set = get_trails('advanced')
    create_trails(trail_set, 21)
  end

  def create_expert
    trail_set = get_trails('expert')
    create_trails(trail_set, 22)
  end

  def create_extreme
    trail_set = get_trails('extreme')
    create_trails(trail_set, 23)
  end

  def set_documents
    @mountain_doc = Nokogiri::HTML(open("http://www.coppercolorado.com/winter/the_mountain/dom/snow.html"))
  end

  def scrape_raw_html(xpath)
    rows = @mountain_doc.xpath(xpath)
    rows.collect do |row|
      {
        :name => row.xpath("td[contains(@class, 'title')]").text,
        :open => row.xpath("//td[contains(@class, 'status_icon')]//img").attribute('src').value,
        :difficulty => row.xpath("td[contains(@class, 'trail icon')]//img").attribute('src').value,
      }
    end
  end

  def format_trails(array)
    array.each do |trail|
      trail[:open]       = trail[:open].scan(/\b(open|groomed|closed)\b/).join
      trail[:difficulty] = trail[:difficulty].scan(/\b(beginner|intermediate|advanced|expert|extreme)\b/).join
    end
  end

  def get_trails(target)
    trail_set = []
    @all_trails.collect do |trail|
      trail[:difficulty] == target ? trail_set << trail : false
    end
    trail_set
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

  def find_snow_depth
    @mountain_doc.xpath("//div[contains(@id, 'report-page')]//table//tr[position() = 3]//td[position() = 1]").map {|x| x.text}[4]
  end

  def find_snow_report
    @mountain_doc.xpath("//div[contains(@id, 'report-page')]//table[contains(@id, 'report-page-conditions-snow')]//tr//td").map {|x| x.text}
  end

  def find_terrian_status
    data = @mountain_doc.xpath("//div[contains(@id, 'report-page')]//table[contains(@id, 'report-page-conditions-status')]//tr//td").map {|x| x.text}
    format_terrain(data)
  end

  def format_terrain(data)
    data.map {|data| data.gsub(/\s{2}/, '')}
  end

  def closed?
    !Mountain.find_by(name: "Copper Mountain").open?
  end
end
