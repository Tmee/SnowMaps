class VailTrail < ActiveRecord::Base

  def initialize
    @doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA8"))
    scrape_for_vail_village_trails
    # scrape_for_back_bowls
    # scrape_for_blue_sky_basin
    # scrape_for_china_bowl
    # scrape_for_golden_peak
    # scrape_for_lionshead
  end

  def scrape_for_vail_village_trails
    rows = @doc.xpath("//div[contains(@id, 'GA8')]//td//tr")
    vail_village_trails = rows.collect do |row|
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

    format_open_and_difficulty(vail_village_trails)

    vail_village_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 1,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def format_open_and_difficulty(array)
    array.delete_at(0)
    array.each do |trail|
      trail[:open] = trail[:open].scan(/\b(noStatus|yesStatus)\b/).join(',')
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',')
    end
  end

  def scrape_for_back_bowls
    rows = @doc.xpath("//div[contains(@id, 'GA4')]//td//tr")
    back_bowl_trails = rows.collect do |row|
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

    back_bowls_trails.delete_at(0)
    back_bowls_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 1,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_blue_sky_basin
    rows = @doc.xpath("//div[contains(@id, 'GA7')]//td//tr")
    back_bowl_trails = rows.collect do |row|
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

    back_bowls_trails.delete_at(0)
    back_bowls_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 1,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_china_bowl
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA6"))

    trail_names = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA6')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

     trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 4
      )
    end
  end

  def scrape_for_golden_peak
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA5"))

    trail_names = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA5')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')
    trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 5
      )
    end
  end

  def scrape_for_lionshead
    doc = Nokogiri::HTML(open("http://www.vail.com/mountain/current-conditions/whats-open-today.aspx#/GA1"))

    trail_names = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 2]//text()").to_a.join(",").split(",")

    difficlutly = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 1]").to_s.scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',').split(',')

    open_status = doc.xpath("//div[contains(@id, 'GA1')]//td//tr/td[position() = 3]").to_s.scan(/\b(noStatus|yesStatus)\b/).join(',').split(',')

     trail_names.each do |trail|
      Trail.create!(name: trail,
                    peak_id: 6
      )
    end
  end
end
