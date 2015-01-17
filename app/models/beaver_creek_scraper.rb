class BeaverCreekScraper < ActiveRecord::Base

  def self.scrape_for_arrowhead
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrpe_for_bachelor_gulch
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrpe_for_beaver_creek
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end


  def scrpe_for_beaver_creek_west
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_birds_of_prey
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_elkhorn
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA9')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA9')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA9')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_grouse_mountain
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_larspur_bowl
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_rose_bowl
    doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    trail_names = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end
end