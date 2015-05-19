class Seed

  def initialize
    generate_mountains
    generate_peaks_and_trails
    remove_blank_trail_names
  end

  def generate_mountains


  end

  def generate_mountains_peaks_and_trails
    ArapahoeBasinScraper.new #1
    puts "Generate A Basin, complete"

    # VailScraper.new          #
    # puts "Generate Vail, complete"

    # KeystoneScraper.new      #2
    # puts "Generate Keystone, complete"

    # BreckenridgeScraper.new  #3
    # puts "Generate Breckenridge, complete"

    # BeaverCreekScraper.new   #4
    # puts "Generate Beaver Creek, complete"


    # LovelandScraper.new      #6
    # puts "Generate Loveland, complete"

    # WinterParkScraper.new    #7
    # puts "Generate Winter Park, complete"

    # TellurideScraper.new     #8
    # puts "Generate Telluride, complete"

    # PowderhornScraper.new    #9
    # puts "Generate Powderhorn, complete"

    # CopperScraper.new        #10
    # puts "Generate Copper, complete"
  end

  def remove_blank_trail_names
    Trail.where(name: '').destroy_all
  end
end

Seed.new