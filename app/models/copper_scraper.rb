class CopperScraper < ActiveRecord::Base

  def initialize
    set_documents
    create_mountain_information
    generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
    snow_report    = find_snow_report
    terrain_status = find_terrian_status
    snow_depth     = find_snow_depth

    Mountain.create!(name:      "Copper Mountain",
                    last_24:        snow_report[1],
                    overnight:      snow_report[8],
                    last_48:        snow_report[9],
                    last_7_days:    snow_report[11],
                    base_depth:     snow_depth,
                    season_total:   snow_report[13],
                    acres_open:     terrain_status[2],
                    lifts_open:     terrain_status[0],
                    runs_open:      terrain_status[1],
                    snow_condition: terrain_status[3],
                    town:            'Copper Mountain'
    )
  end

  def generate_peaks
    copper_peak_names = ['Beginner', 'Intermediate', 'Advanced', 'Expert']
    copper_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 10
      )
    end
  end

  def scrape_for_trails
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
    create_trails(trail_set, 51)
  end

  def create_intermediate
    trail_set = get_trails('intermediate')
    create_trails(trail_set, 52)
  end

  def create_advanced
    trail_set = get_trails('advanced')
    create_trails(trail_set, 53)
  end

  def create_extreme
    trail_set = get_trails('extreme')
    create_trails(trail_set, 54)
  end

  def create_expert
    trail_set = get_trails('expert')
    create_trails(trail_set, 55)
  end


  private

  def set_documents
    @mountain_doc = Nokogiri::HTML(open("http://www.coppercolorado.com/winter/the_mountain/dom/snow.html"))
  end

  def scrape_raw_html(xpath)
    rows = @mountain_doc.xpath(xpath)
    trails = rows.collect do |row|
    detail = {}
    [
      [:name, "td[contains(@class, 'title')]"],
      [:open, "//td[contains(@class, 'status_icon')]//img"],
      [:difficulty, "td[contains(@class, 'trail icon')]//img"],
    ].each do |name, xpath|
      case name
        when :name
          detail[name] = row.at_xpath(xpath).text
        when :open
          detail[name] = row.at_xpath(xpath).attribute('src').value
        when :difficulty
          detail[name] = row.at_xpath(xpath).attribute('src').value
        end
      end
    detail
    end
  end

  def format_trails(array)
    array.each do |trail|
      trail[:open]       = trail[:open].scan(/\b(open|groomed|closed)\b/).join(',')
      trail[:difficulty] = trail[:difficulty].scan(/\b(beginner|intermediate|advanced|expert|extreme)\b/).join(',')
    end
  end

  def get_trails(target_difficulty)
    trail_set = []
    @all_trails.collect do |trail|
      if trail[:difficulty] == target_difficulty
        trail_set << trail
      end
    end
    trail_set
  end

  def create_trails(trails, peak_id)
    trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: peak_id,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
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
    data.map {|data| data.gsub(/\s/, '')}
  end
end
