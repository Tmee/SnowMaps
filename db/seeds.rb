class Seed

  def initialize
    generate_mountains_peaks_and_trails
    remove_blank_trail_names
  end

  def generate_mountains_peaks_and_trails
    VailScraper.new
    puts "Generate Vail complete"

    KeystoneScraper.new
    puts "Generate Keystone complete"

    BreckenridgeScraper.new
    puts "Generate Breckenridge complete"

    BeaverCreekScraper.new
    puts "Generate Beaver Creek complete"

    ArapahoeBasinScraper.new
    puts "Generate A Basin complete"

    LovelandScraper.new
    puts "Generate Loveland complete"
  end

  def remove_blank_trail_names
    Trail.where(name: '').destroy_all
  end
end

Seed.new