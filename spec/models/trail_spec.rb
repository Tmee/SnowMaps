require 'rails_helper'

RSpec.describe Trail, :type => :model do
    let(:trail) do
    Trail.new(name: 'Tim',
              peak_id: 2)
  end


  it "is valid" do
    expect(trail).to be_valid
  end

  it "is invalid without a name" do
    trail.name = nil
    expect(trail).not_to be_valid
  end
end
