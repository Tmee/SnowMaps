class PowderhornScraper < ActiveRecord::Base

  def initialize
    set_documents
    # @mountain = Mountain.find(9)
    create_mountain_information
    generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
    overnight   = @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-24hr-inches')]//div[contains(@class, 'field-items')]").map {|x|x.text.scan(/\d/).join}
    hr_48        = @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-48hr-inches')]//div[contains(@class, 'field-items')]").map {|x|x.text.scan(/\d/).join}
    base        = @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-base-inches')]//div[contains(@class, 'field-items')]").map {|x|x.text}
    acres       = @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-percent-open ')]//div[contains(@class, 'field-items')]").map {|x|x.text}
    conditions  = @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-surface-conditions')]//div[contains(@class, 'field-items')]").map {|x|x.text}
    lifts       = @mountain_doc.xpath("//div//section[contains(@class, 'field-name-field-lifts-open')]//div[contains(@class, 'field-items')]").map {|x|x.text}

    Mountain.create!(name: "Powderhorn Mountain Resort",
                    last_24:       "#{overnight[0]}\"",
                    overnight:      "#{overnight[0]}\"",
                    last_48:        hr_48[0],
                    last_7_days:    '-',
                    base_depth:     base[0],
                    season_total:   '-',
                    acres_open:     acres[0],
                    lifts_open:     lifts[0],
                    runs_open:      "-",
                    snow_condition: conditions[0],
                    town:           'Mesa'
    )
  end

  def generate_peaks
    powderhorn_peak_names = ['Beginner', 'Intermediate', 'Expert']
    powderhorn_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 9
      )
    end
  end

  def scrape_for_trails
    scrape_for_beginner
    scrape_for_intermediate
    scrape_for_expert
  end

  def scrape_for_beginner
    names = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-green')]//div[contains(@class, 'fieldset-wrapper')]//h2").map {|x| x.text}
    status = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-green')]//div[contains(@class, 'fieldset-wrapper')]//div//span").map {|x| x.text}

    array = create_trail_array(names, status, 'beginner')
    create_trails(array, 47)
  end

  def scrape_for_intermediate
    names = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-blue')]//div[contains(@class, 'fieldset-wrapper')]//h2").map {|x| x.text}
    status = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-blue')]//div[contains(@class, 'fieldset-wrapper')]//div//span").map {|x| x.text}

    array = create_trail_array(names, status, 'intermediate')
    create_trails(array, 48)
  end

  def scrape_for_expert
    names = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-black')]//div[contains(@class, 'fieldset-wrapper')]//h2").map {|x| x.text}
    status = @mountain_doc.xpath("//div//fieldset[contains(@class, 'group-snow-black')]//div[contains(@class, 'fieldset-wrapper')]//div//span").map {|x| x.text}

    array = create_trail_array(names, status, 'expert')
    create_trails(array, 49)
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
      Trail.create!(name: trail[:name],
                    peak_id: peak_id,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end
end