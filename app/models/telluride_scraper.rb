class TellurideScraper < ActiveRecord::Base

  def initialize
    set_documents
    create_mountain_information
    # generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
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
    telluride_peak_names = ['Beginner', 'Intermediate', 'Avanced', 'Expert']
    telluride_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 8
      )
    end
  end

  def scrape_for_trails
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
    create_trails(trail_set, 44)
  end

  def create_intermediate
    trail_set = get_trails('levelIntermediate')
    create_trails(trail_set, 45)
  end

  def create_advanced_intermediate
    trail_set = get_trails('AdvancedIntermediate')
    create_trails(trail_set, 45) #not a fuck up
  end

  def create_advanced
    trail_set = get_trails('levelExpert')
    create_trails(trail_set, 46)
  end

  def create_expert
    trail_set = get_trails('levelExtreme')
    create_trails(trail_set, 47)
  end


  private

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
      unless trail[:name] == ''
        Trail.find_by(name: trail[:name]).update(open: trail[:open],
                                                difficulty: trail[:difficulty]
        )
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
      detail = {}
      [
        [:name, 'div[position() = 2]'],
        [:open, 'div[position() = 3]'],
        [:difficulty, 'div[position() = 1]'],
      ].each do |name, xpath|
        case name
        when :name
          detail[name] = row.at_xpath(xpath).child.text
        when :open
          detail[name] = row.at_xpath(xpath).attribute('class').value
        when :difficulty
          detail[name] = row.at_xpath(xpath).attribute('class').value
        end
      end
    detail
    end
  end

  def format_trails(array)
    array.each do |trail|
      trail[:open]       = trail[:open].scan(/\b(keyClosed|keyOpen)\b/).join(',')
      trail[:difficulty] = trail[:difficulty].scan(/\b(levelNovice|levelIntermediate|AdvancedIntermediate|levelExpert|levelExtreme)\b/).join(',')
    end
  end
end
