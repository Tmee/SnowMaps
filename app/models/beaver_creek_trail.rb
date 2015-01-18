class BeaverCreekScraper < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.beavercreek.com/the-mountain/terrain-status.aspx#/TerrainStatus"))
    scrape_for_arrowhead
    scrape_for_bachelor_gulch
    scrape_for_beaver_creek
    scrape_for_beaver_creek_west
    scrape_for_birds_of_prey
    scrape_for_elkhorn
    scrape_for_grouse_mountain
    scrape_for_larspur_bowl
    scrape_for_rose_bowl
  end

  def scrape_for_arrowhead
    trail_names = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 1
      )
    end
  end

  def scrape_for_bachelor_gulch
    trail_names = @doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_beaver_creek
    trail_names = @doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end


  def scrape_for_beaver_creek_west
    trail_names = @doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_birds_of_prey
    trail_names = @doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_elkhorn
    trail_names = @doc.xpath("//div[contains(@id, 'GA9')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA9')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA9')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_grouse_mountain
    trail_names = @doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_larspur_bowl
    trail_names = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_rose_bowl
    trail_names = @doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end
end