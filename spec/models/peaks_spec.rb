require 'rails_helper'

RSpec.describe Peak, :type => :model do
  let(:peak) do
    Peak.new(name: "The Peak")
  end


  it "is valid" do
    expect(peak).to be_valid
  end

  it "is invalid without a name" do
    peak.name = nil
    expect(peak).not_to be_valid
  end
end
