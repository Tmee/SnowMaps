class Seed
  # require 'open-uri'

  def initialize
    generate_mountains
    generate_peaks
    generate_trails
  end

  def generate_mountains
    Mountain.create!(name: 'Vail Resort',
                      last_two_four: '25',
                      overnight: '25',
                      last_four_eight: '2',
                      last_seven_days: '8',
                      acres_open: '5289',
                      acres_total: '5289',
                      lifts_open: '31',
                      lifts_total: '37',
                      runs_open: '195',
                      runs_total: '665',
                      snow_condition: 'all the pow',
                      base_depth: '40',
                      season_total: '165'
    )

    Mountain.create!(name: 'Breckenridge Resort',
                      last_two_four: '20',
                      overnight: '20',
                      last_four_eight: '2',
                      last_seven_days: '8',
                      acres_open: '9289',
                      acres_total: '9289',
                      lifts_open: '31',
                      lifts_total: '31',
                      runs_open: '125',
                      runs_total: '145',
                      snow_condition: 'some serious pow',
                      base_depth: '40',
                      season_total: '165'
    )

    Mountain.create!(name: 'Arapahoe Basin',
                      last_two_four: '17',
                      overnight: '17',
                      last_four_eight: '2',
                      last_seven_days: '8',
                      acres_open: '525  9',
                      acres_total: '5789',
                      lifts_open: '31',
                      lifts_total: '41',
                      runs_open: '195',
                      runs_total: '905',
                      snow_condition: 'yellow',
                      base_depth: '40',
                      season_total: '165'
    )

    Mountain.create!(name: 'Keystone Resort',
                      last_two_four: '15',
                      overnight: '15',
                      last_four_eight: '2',
                      last_seven_days: '10',
                      acres_open: '52867',
                      acres_total: '6542',
                      lifts_open: '23',
                      lifts_total: '31',
                      runs_open: '125',
                      runs_total: '225',
                      snow_condition: 'powpow',
                      base_depth: '40',
                      season_total: '15'
    )

    Mountain.create!(name: 'Loveland Ski Area',
                      last_two_four: '11',
                      overnight: '11',
                      last_four_eight: '2',
                      last_seven_days: '8',
                      acres_open: '5229',
                      acres_total: '5349',
                      lifts_open: '31',
                      lifts_total: '41',
                      runs_open: '192',
                      runs_total: '195',
                      snow_condition: 'boiler plate',
                      base_depth: '4',
                      season_total: '165'
    )

    Mountain.create!(name: 'Beaver Creek Resort',
                      last_two_four: '11',
                      overnight: '11',
                      last_four_eight: '2',
                      last_seven_days: '8',
                      acres_open: '5229',
                      acres_total: '5349',
                      lifts_open: '31',
                      lifts_total: '41',
                      runs_open: '192',
                      runs_total: '195',
                      snow_condition: 'boiler plate',
                      base_depth: '4',
                      season_total: '165'
    )

    puts 'Mountains created'
  end

  def generate_peaks
    vail_peak_names = ['Vail Village', 'Back Bowls', 'Blue Sky Basin', 'China Bowl', 'Golden Peak', 'Lionshead', 'Chairlift Status']

    breckenridge_peak_names = ['Peak 7', 'Peak 8', 'Peak 9', 'Peak 10', 'Terrain Parks', 'T-bar', 'Bowls', 'Peak 6', 'Lifts']

    loveland_peak_names = ['Chair 1', 'Chair 2', 'Chair 3', 'Chair 4', 'Chair 6', 'Chair 7', 'Chair 8', 'Chair 9', 'Magic Carpet']

    keystone_peak_names = ['Dercum Mountain', 'A51 Terrain Park', 'North Peak', 'Outback', 'Lifts']

    arapahoe_basin_peak_names = ['Front Side', 'Back Side']

    vail_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: '1'
      )
    end

    breckenridge_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: '2'
      )
    end

    arapahoe_basin_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: '3'
      )
    end

    keystone_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: '4'
      )
    end

    loveland_peak_names.each do |peak|
      Peak.create!(name: peak,
                  mountain_id: '5'
      )
    end

     puts 'Peaks created'
  end

  def generate_trails
    VailTrail.new
    puts "Generated Vail's trails"

    BreckenridgeTrail.new
    puts "Generated Breckenridge's trails"
  end
    # dercum_mountain = ['Bear Tree', 'Orfint Boy', 'Paymaster', 'Discovery']
    # a_51 = ['Easy Street', 'I-70', 'Park Lane', 'The Ally', 'Main Steet', 'Quarter Pipe']

    # peak_7.each do |trail|
    # Trail.create!(name: trail,
    #               peak_id: 8
    # )
    # end

    # peak_9.each do |trail|
    # Trail.create!(name: trail,
    #               peak_id: 10
    # )
    # end

    # dercum_mountain.each do |trail|
    # Trail.create!(name: trail,
    #               peak_id: 19
    # )
    # end

    # a_51.each do |trail|
    # Trail.create!(name: trail,
    #               peak_id: 20
    # )
    # end
    # puts 'Trails created'
end

Seed.new