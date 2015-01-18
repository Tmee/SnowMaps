class BeaverCreekTrail < ActiveRecord::Base

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
    arrowhead_trails = scrape_raw_html("//div[contains(@id, 'GA4')]//td//tr")

    format_open_and_difficulty(arrowhead_trails)

    arrowhead_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_bachelor_gulch
    bachelor_gulch_trails = scrape_raw_html("//div[contains(@id, 'GA3')]//td//tr")

    format_open_and_difficulty(bachelor_gulch_trails)

    bachelor_gulch_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_beaver_creek
    beaver_creek_trails = scrape_raw_html("//div[contains(@id, 'GA1')]//td//tr")

    format_open_and_difficulty(beaver_creek_trails)

    beaver_creek_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end


  def scrape_for_beaver_creek_west
    beaver_creek_west_trails = scrape_raw_html("//div[contains(@id, 'GA2')]//td//tr")

    format_open_and_difficulty(beaver_creek_west_trails)

    beaver_creek_west_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_birds_of_prey
    bird_of_prey_trails = scrape_raw_html("//div[contains(@id, 'GA8')]//td//tr")

    format_open_and_difficulty(bird_of_prey_trails)

    bird_of_prey_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_elkhorn
    elkhorn_trails = scrape_raw_html("//div[contains(@id, 'GA9')]//td//tr")

    format_open_and_difficulty(elkhorn_trails)

    elkhorn_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_grouse_mountain
    grouse_mountain_trails = scrape_raw_html("//div[contains(@id, 'GA5')]//td//tr")

    format_open_and_difficulty(grouse_mountain_trails)

    grouse_mountain_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_larspur_bowl
    larspur_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA7')]//td//tr")

    format_open_and_difficulty(arrowhead_trails)

    arrowhead_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
                    open: trail[:open],
                    difficulty: trail[:difficulty]
      )
    end
  end

  def scrape_for_rose_bowl
    rose_bowl_trails = scrape_raw_html("//div[contains(@id, 'GA6')]//td//tr")

    format_open_and_difficulty(rose_bowl_trails)

    rose_bowl_trails.each do |trail|
      Trail.create!(name: trail[:name],
                    peak_id: 9,
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
      trail[:difficulty] = trail[:difficulty].scan(/\b(easiest|moreDifficult|mostDifficult)\b/).join(',')
    end
  end
end