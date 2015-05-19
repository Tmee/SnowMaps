class TellurideScraper

  def initialize
    set_documents
    generate_mountain
    generate_mountain_information
    generate_peaks
    generate_trails
  end

  def generate_mountain
    if Mountain.find_by(name: 'Telluride Resort').nil?
      Mountain.create!(name: 'Telluride Resort')
    end
  end

  def generate_mountain_information
    trails_open         = find_open_count("//div[contains(@class, 'trailsOpen')]")
    lifts_open          = find_open_count("//div[contains(@class, 'liftsOpen')]")
    snow_report         = find_snow_report
    base_and_conditions = find_snow_surface

    Mountain.find(8).update(last_24:        snow_report[1],
                            overnight:      snow_report[0],
                            last_48:        snow_report[2],
                            last_7_days:    snow_report[4],
                            base_depth:     base_and_conditions[0],
                            season_total:   snow_report[5],
                            acres_open:     '-',
                            lifts_open:     "#{lifts_open} of 18",
                            runs_open:      "#{trails_open} of 148",
                            snow_condition: base_and_conditions[1]
    )
  end

  def generate_peaks
    if Mountain.find(8).peaks.empty?
      ['Beginner', 'Intermediate', 'Avanced', 'Expert'].each do |peak|
        Peak.create!(name: peak, mountain_id: 8)
      end
    end
  end

  def generate_trails
    scrape_all_trails
    create_beginner
    create_intermediate
    create_advanced
    create_expert
  end

  def scrape_all_trails
    trails = scrape_raw_html("//div[contains(@class, 'allTrails')]//ul//li")
    @all_trails = format_trails(trails)
  end

  def create_beginner
    trail_set = get_trails('levelNovice')
    create_trails(trail_set, 40)
  end

  def create_intermediate
    trail_set = get_trails('levelIntermediate')
    create_trails(trail_set, 41)
  end

  def create_advanced_intermediate
    trail_set = get_trails('AdvancedIntermediate')
    create_trails(trail_set, 41) #not a fuck up
  end

  def create_advanced
    trail_set = get_trails('levelExpert')
    create_trails(trail_set, 42)
  end

  def create_expert
    trail_set = get_trails('levelExtreme')
    create_trails(trail_set, 43)
  end

  def set_documents
    @mountain_doc = Nokogiri::HTML(open("http://www.tellurideskiresort.com/the-mountain/snow-report/"))
  end

  def find_snow_report
    @mountain_doc.xpath("//div[contains(@class, 'snowreportConditions')]//ul//li//div[position() = 2]").map {|x| x.text.gsub(/\s/, '')}
  end

  def find_open_count(xpath)
    @mountain_doc.xpath(xpath).children[3].text
  end

  def find_snow_surface
    @mountain_doc.xpath("//div[contains(@class, 'baseInfo')][position() = 1]//div[contains(@class, 'value')]").map {|x|x.text.gsub(/\s{2}/,'')}
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
        Trail.find_by(name: trail[:name]).update(open: trail[:open])
      end
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

  def scrape_raw_html(xpath)
    rows = @mountain_doc.xpath(xpath)
    rows.collect do |row|
      {
        :name => row.xpath("div[contains(@class, 'title')]").text,
        :open => row.xpath("div[position() = 3]//@class").text,
        :difficulty => row.xpath("div[position() = 1]//@class").text
      }
    end
  end

  def format_trails(array)
    array.each do |trail|
      trail[:open]       = trail[:open].scan(/\b(keyClosed|keyOpen)\b/).join
      trail[:difficulty] = trail[:difficulty].scan(/\b(levelNovice|levelIntermediate|AdvancedIntermediate|levelExpert|levelExtreme)\b/).join
    end
  end
end
