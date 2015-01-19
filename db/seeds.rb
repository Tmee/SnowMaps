class Seed

  def initialize
    generate_mountains_peaks_and_trails
  end

  def generate_peaks
    loveland_peak_names = ['Chair 1', 'Chair 2', 'Chair 3', 'Chair 4', 'Chair 6', 'Chair 7', 'Chair 8', 'Chair 9', 'Magic Carpet']

    # loveland_peak_names.each do |peak|
    #   Peak.create!(name: peak,
    #               mountain_id: '5'
    #   )
    # end
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
    puts "this should really be working"
  end
end

Seed.new