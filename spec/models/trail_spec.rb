require 'rails_helper'


RSpec.describe Trail, :type => :model do

  let(:trail) do
    Trail.new(name: 'Tim',
              open: 'open',
              difficulty: 'easy',
              peak_id: 2)
  end


  it "is valid" do
    expect(trail).to be_valid
  end

  it "is invalid without a name" do
    trail.name = nil
    expect(trail).not_to be_valid
  end

  it "is a beginner trail" do
    assert(trail.beginner?)
  end

  it "is not an intermediate trail" do
     refute(trail.intermediate?)
  end

  it "is not an advanced trail" do
     refute(trail.advanced?)
  end

  it "is not an expert trail" do
     refute(trail.expert?)
  end

  it "is not a park trail" do
     refute(trail.park?)
  end

  it "is a open trail" do
     assert(trail.open?)
  end

  it "is not a closed trail" do
     refute(trail.closed?)
  end
end