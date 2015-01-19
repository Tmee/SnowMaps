class ArapahoeBasinScraper < ActiveRecord::Base

  def initialize
    @terrain_doc = Nokogiri::HTML(open("http://www.arapahoebasin.com/ABasin/snow-conditions/terrain.aspx"))
    @mountain_doc = Nokogiri::HTML(open("http://www.arapahoebasin.com/ABasin/snow-conditions/default.aspx"))
    create_mountain_information
    generate_peak_names
    # scrape_for_trails
  end


  def create_mountain_information
    depth      = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//li[position() = 3]").text
    last_48    = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//li[position() = 2]").text
    last_24    = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//li[position() = 1]").text
    conditions = @mountain_doc.xpath("//div//section[contains(@id, 'mountain-conditions')]//li[position() = 4]").text
    lifts_open = "ball sack"

    x = @mountain_doc.at('div:has(h2[text() = "Lifts Open"])').text.delete("\r\n\t").gsub(/\s{15}/, ',').split(',')
    x.collect {|x| x.strip}
    x.reject(&:empty?)
    z = x[5..-1]
    z.collect {|x| x.strip}
    a = z.reject(&:empty?)
    a.collect {|x| x.strip}
    q = a.reject(&:empty?)

    Mountain.create!(name:      "Arapahoe Basin",
                    last_24:        last_24,
                    last_48:        last_48,
                    last_7_days:    "not available",
                    base_depth:     depth,
                    season_total:   "report[5]",
                    acres_open:     "report[6]",
                    lifts_open:     "#{lifts_open} of 8",
                    runs_open:      'none',
                    snow_condition: conditions
    )
  end


  def scrape_for_back_side
    back_side_trail_status = @terrain_doc.xpath("//div//article//ul[contains(@class, 'runs-list')]//li//a//span").text.delete("\r\n").split(' ')[0..15]

    back_side_trail_names =  @terrain_doc.xpath("//div//article//ul[contains(@class, 'runs-list')]//li//a").text.gsub(/open/,"").gsub(/closed/,"").delete("\r\n").gsub(/\s/, '').split('-')

    back_side_trail_difficulty = []
    @terrain_doc.xpath("//div//article//ul[contains(@class, 'runs-list')]//li").each do |run|
      back_side_trail_difficulty << run.attr('class')
    end
  end

  def generate_peak_names
    arapahoe_basin_peak_names = ['Front Side', 'Back Side']
    arapahoe_basin_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: 5
      )
    end
  end

protected

  def scrape_raw_html(xpath)
    rows = @terrain_doc.xpath(xpath)
    trails_array = rows.collect do |row|
    detail = {}
    [
      [:name, 'td[position() = 2]//text()'],
      [:open, 'td[position() = 3]'],
      [:difficulty, 'td[position() = 1]'],
    ].each do |name, xpath|
      detail[name] = row.at_xpath(xpath).to_s.strip
      end
    detail
    end
  end

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open] = trail[:open].text.delete("\r\n").split(' ')
      trail[:difficulty] = trail[:difficulty].scan(/\b(beg|int|adv|exp)\b/).join(',')
    end
  end
end