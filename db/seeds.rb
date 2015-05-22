class Seed

  def initialize
    generate_mountains_peaks_and_trails
  end

  def generate_mountains_peaks_and_trails
    ArapahoeBasinScraper.new  #1
    puts "Generate A Basin, complete"

    BeaverCreekScraper.new    #2
    puts "Generate Beaver Creek, complete"

    BreckenridgeScraper.new   #3
    puts "Generate Breckenridge, complete"

    CopperScraper.new         #4
    puts "Generate Copper, complete"

    KeystoneScraper.new       #5
    puts "Generate Keystone, complete"

    LovelandScraper.new       #6
    puts "Generate Loveland, complete"

    PowderhornScraper.new     #7
    puts "Generate Powderhorn, complete"

    TellurideScraper.new      #8
    puts "Generate Telluride, complete"

    VailScraper.new           #9
    puts "Generate Vail, complete"

    WinterParkScraper.new     #10
    puts "Generate Winter Park, complete"
  end
end

Seed.new