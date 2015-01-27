class ArapahoeBasinScraper < ActiveRecord::Base

  def initialize
    set_documents
    generate_mountain_information
    generate_peak
    scrape_for_trails
  end

  def generate_mountain_information
    new_snow = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//ul//li//strong//text()").map {|x| x.to_s.split(' ').join}
    lifts_open = count_the_lifts

    Mountain.create!(name:      "Arapahoe Basin",
                    last_24:        new_snow[0],
                    overnight:      new_snow[0],
                    last_48:        new_snow[1],
                    last_7_days:    "-",
                    base_depth:     new_snow[2],
                    season_total:   "-",
                    acres_open:     "-",
                    lifts_open:     lifts_open,
                    runs_open:      "#{new_snow[-1]} of front side",
                    snow_condition: new_snow[3],
                    town:           "Keystone"
    )
  end

  def generate_peak
    Peak.create!(name: 'All Trails',
                mountain_id: 5
    )
  end

  def scrape_for_trails
    back_side_trails = scrape_raw_html("//div//article//ul[contains(@class, 'runs-list')]//li")
    format_name_open_difficulty(back_side_trails)

    back_side_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 28,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
        )
    end
  end

private

  def count_the_lifts
    raw_data_array = @mountain_doc.at('div:has(h2[text() = "Lifts Open"])').text.delete("\r\n\t").gsub(/\s{15}/, ',').split(',')
    raw_data_array.reject!(&:empty?)
    raw_data_array[5..-1].count
  end

  def set_documents
    @terrain_doc  = Nokogiri::HTML(open("http://www.arapahoebasin.com/ABasin/snow-conditions/terrain.aspx"))
    @mountain_doc = Nokogiri::HTML(open("http://www.arapahoebasin.com/ABasin/snow-conditions/default.aspx"))
  end

  def scrape_raw_html(xpath)
    rows = @terrain_doc.xpath("//div//article//ul[contains(@class, 'runs-list')]//li")
    trails_array = rows.collect do |row|
    detail = {}
    [
      [:name, 'a//text()'],
      [:open, 'a//span//text()'],
      [:difficulty, '@class'],
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
    end
    detail
    end
  end

  def format_name_open_difficulty(array)
    array.each do |trail|
      trail[:name] = trail[:name].gsub(/open/,"").gsub(/closed/,"").delete("\r\n").gsub(/\s/, '').split('-').join(',')
      trail[:open] = trail[:open].delete("\r\n").split(' ').join(',')
      trail[:difficulty] = trail[:difficulty].scan(/\b(beg|int|adv|exp|terrain)\b/).join(',')
    end
  end
end