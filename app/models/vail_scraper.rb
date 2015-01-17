class VailScraper < ActiveRecord::Base

  def initialize
    scrape_for_vail_village_trails
    scrape_for_back_bowls
    scrape_for_blue_sky_basin
    scrape_for_china_bowl
    scrape_for_golden_peak
    scrape_for_lionshead
  end

  def scrape_for_vail_village_trails
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA8"))
    trail_names = doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")
    difficlutly = doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')
    open_status = doc.xpath("//div[contains(@id, 'GA8')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 1
      )
    end
  end

  def scrape_for_back_bowls
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA4"))

    trail_names = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA4')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_blue_sky_basin
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA7"))

     trail_names = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA7')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_china_bowl
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA6"))

     trail_names = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_golden_peak
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA5"))

     trail_names = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end

  def scrape_for_lionshead
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA1"))

     trail_names = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
  end
end
