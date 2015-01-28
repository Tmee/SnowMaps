require 'rails_helper'

RSpec.describe Mountain, :type => :model do
  let(:mountain) do
    Mountain.create!(name: 'Tim Tim')
  end


  it "is valid" do
    expect(mountain).to be_valid
  end

  it "is invalid without a name" do
    mountain.name = nil
    expect(mountain).not_to be_valid
  end

  it "generates slug" do
    expect(mountain.slug).to eq("tim-tim")
  end
end