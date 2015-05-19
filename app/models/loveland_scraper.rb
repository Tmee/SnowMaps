class LovelandScraper

  def initialize
    set_documents
    generate_mountain
    generate_mountain_information
    generate_peaks
    generate_trails
  end

  def generate_mountain
    if Mountain.find_by(name: "Loveland Ski Area").nil?
      Mountain.create!(name: "Loveland Ski Area")
    end
  end

  def generate_mountain_information
    report = scrape_mountain_information

    Mountain.find(6).update(last_24:        "#{report[0]}\"",
                            overnight:      "#{report[0]}\"",
                            last_48:        "#{report[1]}\"",
                            last_7_days:    '-',
                            base_depth:     "#{report[3]}\"",
                            season_total:   "#{report[4]}\"",
                            acres_open:     report[8],
                            lifts_open:     report[5],
                            runs_open:      report[6],
                            snow_condition: report[7]
    )
  end

  def generate_peaks
    loveland_peak_names = ['Chair 1', 'Chair 2', 'Chair 3', 'Chair 4', 'Chair 6', 'Chair 7', 'Chair 8', 'Chair 9', 'Magic Carpet']

    loveland_peak_names.each do |peak|
      if Peak.find_by(name: peak).nil?
        Peak.create!(name: peak,
                     mountain_id: 6)
      end
    end
  end

  def generate_trails
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
    chair_1_trails = scrape_raw_html(1)
    format_open_and_difficulty(chair_1_trails)
    create_trails(chair_1_trails, 28)
  end

  def scrape_for_chair_2
    chair_2_trails = scrape_raw_html(2)
    format_open_and_difficulty(chair_2_trails)
    create_trails(chair_2_trails, 29)
  end

  def scrape_for_chair_3
    chair_3_trails = scrape_raw_html(3)
    format_open_and_difficulty(chair_3_trails)
    create_trails(chair_3_trails, 30)
  end

  def scrape_for_chair_4
    chair_4_trails = scrape_raw_html(4)
    format_open_and_difficulty(chair_4_trails)
    create_trails(chair_4_trails, 31)
  end

  def scrape_for_chair_6
    chair_6_trails = scrape_raw_html(6)
    format_open_and_difficulty(chair_6_trails)
    create_trails(chair_6_trails, 32)
  end

  def scrape_for_chair_7
    chair_7_trails = scrape_raw_html(7)
    format_open_and_difficulty(chair_7_trails)
    create_trails(chair_7_trails, 33)
  end

  def scrape_for_chair_8
    chair_8_trails = scrape_raw_html(8)
    format_open_and_difficulty(chair_8_trails)
    create_trails(chair_8_trails, 34)
  end

  def scrape_for_chair_9
    chair_9_trails = scrape_raw_html(9)
    format_open_and_difficulty(chair_9_trails)
    create_trails(chair_9_trails, 35)
  end

  def scrape_for_magic_carpet
    chair_12_trails = scrape_raw_html(12)
    format_open_and_difficulty(chair_12_trails)
    create_trails(chair_12_trails, 36)
  end

  def set_documents
    @mountain_doc = Nokogiri::HTML(open("http://www.skiloveland.com/themountain/reports/snowreport.aspx"))
    @terrain_doc  = Nokogiri::HTML(open("http://www.skiloveland.com/themountain/reports/runstats.aspx"))
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

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open]       = trail[:open].to_s.scan(/\b(open|closed)\b/).join
      trail[:difficulty] = trail[:difficulty].to_s.scan(/\b(beginner|intermediate|expert|advanced|park)\b/).join
    end
  end

  def scrape_raw_html(lift_number)
    rows = @terrain_doc.xpath("//div[contains(@id, 'Lift #{lift_number}')]//tr")
    rows.collect do |row|
      {
        :name => row.xpath("td[position() = 3]//text()").text,
        :open => row.xpath("td[position() = 2]//img"),
        :difficulty => row.xpath("td[position() = 1]//img")
      }
    end
  end

  def scrape_mountain_information
    @mountain_doc.xpath("//div[contains(@id, 'report')]//tr//td[position() = 2]//text()").map {|x| x.text}[5..-1]
  end
end