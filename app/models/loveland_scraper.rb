class LovelandScraper < ActiveRecord::Base

  def initialize
    set_documents
    create_mountain_information
    generate_peaks
    scrape_for_trails
  end

  def create_mountain_information
    report = scrape_mountain_information

    Mountain.create!(name:   "Loveland Ski Area",
                        last_24:        "#{report[0]} \"",
                        overnight:      "#{report[0]} \"",
                        last_48:        "#{report[1]} \"",
                        last_7_days:    '-',
                        base_depth:     "#{report[3]} \"",
                        season_total:   "#{report[4]} \"",
                        acres_open:     report[8],
                        lifts_open:     report[5],
                        runs_open:      report[6],
                        snow_condition: report[7]
    )
  end

  def generate_peaks
    loveland_peak_names = ['Chair 1', 'Chair 2', 'Chair 3', 'Chair 4', 'Chair 6', 'Chair 7', 'Chair 8', 'Chair 9', 'Magic Carpet']

    loveland_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 6
      )
    end
  end

  def scrape_for_trails
    scrape_for_chair_1
    scrape_for_chair_2
    scrape_for_chair_3
    scrape_for_chair_4
    scrape_for_chair_6
    scrape_for_chair_7
    scrape_for_chair_8
    scrape_for_chair_9
    scrape_for_magic_carpet
  end

  def scrape_for_chair_1
    chair_1_trails = scrape_raw_html("//div[contains(@id, 'Lift 1')]//tr")
    format_open_and_difficulty(chair_1_trails)
    chair_1_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 29,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_2
    chair_2_trails = scrape_raw_html("//div[contains(@id, 'Lift 2')]//tr")
    format_open_and_difficulty(chair_2_trails)
    chair_2_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 30,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_3
    chair_3_trails = scrape_raw_html("//div[contains(@id, 'Lift 3')]//tr")
    format_open_and_difficulty(chair_3_trails)
    chair_3_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 31,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_4
    chair_4_trails = scrape_raw_html("//div[contains(@id, 'Lift 4')]//tr")
    format_open_and_difficulty(chair_4_trails)
    chair_4_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 32,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_6
    chair_6_trails = scrape_raw_html("//div[contains(@id, 'Lift 6')]//tr")
    format_open_and_difficulty(chair_6_trails)
    chair_6_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 33,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_7
    chair_7_trails = scrape_raw_html("//div[contains(@id, 'Lift 7')]//tr")
    format_open_and_difficulty(chair_7_trails)
    chair_7_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 34,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_8
    chair_8_trails = scrape_raw_html("//div[contains(@id, 'Lift 8')]//tr")
    format_open_and_difficulty(chair_8_trails)
    chair_8_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 35,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_chair_9
    chair_9_trails = scrape_raw_html("//div[contains(@id, 'Lift 9')]//tr")
    format_open_and_difficulty(chair_9_trails)
    chair_9_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 36,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_magic_carpet
    chair_12_trails = scrape_raw_html("//div[contains(@id, 'Lift 12')]//tr")
    format_open_and_difficulty(chair_12_trails)
    chair_12_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 37,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  private

  def format_open_and_difficulty(data)
    data.delete_at(0)
    data.each do |data|
      data[:open]       = data[:open].to_s.scan(/\b(open|closed)\b/).join
      data[:difficulty] = data[:difficulty].to_s.scan(/\b(beginner|intermediate|expert|advanced|park)\b/).join
    end
  end

  def scrape_raw_html(xpath)
    rows = @terrain_doc.xpath(xpath)
    trails_array = rows.collect do |row|
    detail = {}
    [
      [:name, 'td[position() = 3]//text()'],
      [:open, 'td[position() = 2]//img'],
      [:difficulty, 'td[position() = 1]//img'],
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
      end
    detail
    end
  end

  def set_documents
    @mountain_doc  = Nokogiri::HTML(open("http://www.skiloveland.com/themountain/reports/snowreport.aspx"))
    @terrain_doc      = Nokogiri::HTML(open("http://www.skiloveland.com/themountain/reports/runstats.aspx"))
  end


  def scrape_mountain_information
    @mountain_doc.xpath("//div[contains(@id, 'report')]//tr//td[position() = 2]//text()").map {|x| x.text}[5..-1]
  end

end
