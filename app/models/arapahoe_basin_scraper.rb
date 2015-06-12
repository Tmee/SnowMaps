class ArapahoeBasinScraper

  def initialize
    set_documents
    generate_mountain
    generate_mountain_information
    generate_peak
    generate_trails
  end

  private

  def generate_mountain
    if Mountain.find_by(name: "Arapahoe Basin").nil?
      Mountain.create!(name: "Arapahoe Basin")
    end
  end

  def generate_mountain_information
    new_snow = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//ul//li//strong//text()").map {|x| x.to_s.split(' ').join}
    lifts_open = count_the_lifts

    Mountain.find(1).update(last_24:        new_snow[0],
                            overnight:      new_snow[0],
                            last_48:        new_snow[1],
                            last_7_days:    "-",
                            base_depth:     new_snow[2],
                            season_total:   "-",
                            acres_open:     "-",
                            lifts_open:     lifts_open,
                            runs_open:      "-",
                            snow_condition: new_snow[3])
  end


  def generate_trails
    trails = scrape_raw_html
    format_name_open_difficulty(trails)

    trails.each do |trail|
      unless trail[:name] == ''
        if Trail.find_by(name: trail[:name]).nil?
          Trail.create!(name: trail[:name],
                        open: trail[:open],
                        difficulty: trail[:difficulty],
                        peak_id: 1)
        else
          Trail.find_by(name: trail[:name]).update_attributes(open: trail[:open])
        end
      end
    end
  end

  def generate_peak
    if Peak.find_by(mountain_id: 1).nil?
      Peak.create!(name: 'All Trails',
                   mountain_id: 1)
    end
  end

  def count_the_lifts
    raw_data_array = @mountain_doc.at('div:has(h2[text() = "Lifts Open"])').text.delete("\r\n\t").gsub(/\s{15}/, ',').split(',')
    raw_data_array.reject!(&:empty?)
    raw_data_array[5..-1].count
  end

  def set_documents
    @terrain_doc  = Nokogiri::HTML(open("http://www.arapahoebasin.com/ABasin/snow-conditions/terrain.aspx"))
    @mountain_doc = Nokogiri::HTML(open("http://www.arapahoebasin.com/ABasin/snow-conditions/default.aspx"))
  end

  def scrape_raw_html
    rows = @terrain_doc.xpath("//div//article//ul[contains(@class, 'runs-list')]//li")

    rows.collect do |row|
      {
        :name => row.xpath("a/text()[1]").text,
        :open => row.xpath("a//span//text()").text,
        :difficulty => row.xpath("@class").text
      }
    end
  end

  def format_name_open_difficulty(array)
    array.each do |trail|
      trail[:name] = trail[:name].delete("\r\n").gsub(/\s{2}/, '')
      trail[:open] = trail[:open].scan(/[a-zA-Z]/).join
      trail[:difficulty] = trail[:difficulty].scan(/\b(beg|int|adv|exp|terrain)\b/).join(',')
    end
  end
end
