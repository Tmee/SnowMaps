class BreckenridgeScraper < ActiveRecord::Base

  def self.scrape_for_peak_7
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_peak_8
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_peak_9
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_peak_10
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_terrain_parks
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA9001')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA9001')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA9001')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_t_bar
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_bowls
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def self.scrape_for_peak_6
    doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    trail_names = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end
end
