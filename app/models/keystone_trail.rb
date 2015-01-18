class KeystoneTrail < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.keystoneresort.com/ski-and-snowboard/terrain-status.aspx#/TerrainStatus"))
    scrape_for_outback
    scrape_for_dercum_trails
    scrape_for_a51_trails
    scrape_for_north_peak
  end

  def scrape_for_dercum_trails
    dercum_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")

    format_open_and_difficulty(dercum_trails)

    dercum_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 19,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_a51_trails
    a51_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")

    format_open_and_difficulty(a51_trails)

    a51_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 20,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_north_peak
    north_peak_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")

    format_open_and_difficulty(north_peak_trails)

    north_peak_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 21,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_outback
    outback_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")

    format_open_and_difficulty(outback_trails)

    outback_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 22,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  protected

  def scrape_raw_html(xpath)
    rows = @doc.xpath(xpath)
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
      trail[:open] = trail[:open].scan(/\b(noStatus|yesStatus)\b/).join(',')
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult|doubleDiamond)\b/).join(',')
    end
  end
end