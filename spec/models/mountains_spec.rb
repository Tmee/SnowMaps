require 'rails_helper'

RSpec.describe Mountain, :type => :model do
  let(:mountain) do
    Mountain.new(name: 'Tim')
  end


  it "is valid" do
    expect(mountain).to be_valid
  end

  it "is invalid without a name" do
    mountain.name = nil
    expect(mountain).not_to be_valid
  end

end
