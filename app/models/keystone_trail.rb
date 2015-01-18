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
                    peak_id: 12,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
    trail_names = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_a51_trails

    trail_names = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_north_peak
    trail_names = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_outback

    trail_names = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end
end