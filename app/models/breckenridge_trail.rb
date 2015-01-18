class BreckenridgeScraper < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.breckenridge.com/mountain/terrain-status.aspx#/GA4"))
    scrape_for_peak_6
    scrape_for_peak_7
    scrape_for_peak_8
    scrape_for_peak_9
    scrape_for_peak_10
    scrape_for_terrain_parks
    scrape_for_t_bar
    scrape_for_bowls
  end

  def scrape_for_peak_7
    trail_names = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 8
      )
    end
  end

  def scrape_for_peak_8
    trail_names = @doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 9
      )
    end
  end

  def scrape_for_peak_9
    trail_names = @doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA2')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 10
      )
    end
  end

  def scrape_for_peak_10
    trail_names = @doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA3')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 11
      )
    end
  end

  def scrape_for_terrain_parks
    trail_names = @doc.xpath("//div[contains(@id, 'GA9001')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA9001')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA9001')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 12
      )
    end
  end

  def scrape_for_t_bar
    trail_names = @doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 13
      )
    end
  end

  def scrape_for_bowls
    trail_names = @doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 14
      )
    end
  end

  def scrape_for_peak_6
    trail_names = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 15
      )
    end
  end
end
