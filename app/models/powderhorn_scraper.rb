class PowderhornScraper

  def initialize
    set_documents
    generate_mountain
    generate_mountain_information
    generate_peaks
    generate_trails
  end

  def generate_mountain
    if Mountain.find_by(name: "Powderhorn Ski Area").nil?
      Mountain.create!(name: "Powderhorn Ski Area")
    end
  end

  def mountain_info_field(section)
    @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-#{section}')]//div[contains(@class, 'field-items')]").map {|x|x.text.scan(/\d/).join}
  end

  def generate_mountain_information
    overnight  = mountain_info_field('24hr-inches')
    hr_48      = mountain_info_field('48hr-inches')
    base       = mountain_info_field('base-inches')
    acres      = mountain_info_field('percent-open')
    conditions = mountain_info_field('surface-conditions')
    lifts      = mountain_info_field('lifts-open')

    Mountain.find(7).update(last_24:       "#{overnight[0]}\"",
                            overnight:      "#{overnight[0]}\"",
                            last_48:        hr_48[0],
                            last_7_days:    '-',
                            base_depth:     base[0],
                            season_total:   '-',
                            acres_open:     acres[0],
                            lifts_open:     lifts[0],
                            runs_open:      "-",
                            snow_condition: conditions[0]
    )
  end

  def generate_peaks
    if Mountain.find(7).peaks.empty?
      ['Beginner', 'Intermediate', 'Expert'].each do |peak|
        Peak.create!(name: peak,
                     mountain_id: 7)
      end
    end
  end

  def generate_trails
    scrape_for_beginner
    scrape_for_intermediate
    scrape_for_expert
  end

  def scrape_for_beginner
    names = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-green')]//div[contains(@class, 'fieldset-wrapper')]//h2").map {|x| x.text}
    status = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-green')]//div[contains(@class, 'fieldset-wrapper')]//div//span").map {|x| x.text}

    array = create_trail_array(names, status, 'beginner')
    create_trails(array, 37)
  end

  def scrape_for_intermediate
    names = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-blue')]//div[contains(@class, 'fieldset-wrapper')]//h2").map {|x| x.text}
    status = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-blue')]//div[contains(@class, 'fieldset-wrapper')]//div//span").map {|x| x.text}

    array = create_trail_array(names, status, 'intermediate')
    create_trails(array, 38)
  end

  def scrape_for_expert
    names = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-black')]//div[contains(@class, 'fieldset-wrapper')]//h2").map {|x| x.text}
    status = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-black')]//div[contains(@class, 'fieldset-wrapper')]//div//span").map {|x| x.text}

    array = create_trail_array(names, status, 'expert')
    create_trails(array, 39)
  end


  private

  def set_documents
    @mountain_doc = Nokogiri::HTML(open("http://www.powderhorn.com/snow-report"))
  end

  def create_trail_array(names, status, difficulty)
    array = []
    names.each_with_index do |value, index|
      hash  = {}
      hash[:open]       = status[index].downcase.gsub('groomed', 'open')
      hash[:name]       = value
      hash[:difficulty] = difficulty
      array << hash
    end
    array
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
end