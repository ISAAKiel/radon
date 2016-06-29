require 'rails_helper'

describe "Sites" do

  it "has a valid factory" do
    expect(FactoryGirl.build(:site)).to be_valid
  end

  it "has a valid factory also for samples"

  it "should have accessible :name" do
    expect { Site.new(name: 'name') }.not_to raise_error
  end

  it "should have accessible :parish" do
    expect { Site.new(parish: 'parish') }.not_to raise_error
  end

  it "should have accessible :district" do
    expect { Site.new(district: 'district') }.not_to raise_error
  end

  it "should have accessible :country_subdivision_id" do
    expect { Site.new(country_subdivision_id: 'country_subdivision_id') }.not_to raise_error
  end

  it "should have accessible :lat" do
    expect { Site.new(lat: 'lat') }.not_to raise_error
  end

  it "should have accessible :lng" do
    expect { Site.new(lng: 'lng') }.not_to raise_error
  end

  it "should have many :samples" do
    t = Site.reflect_on_association(:samples)
    expect(t.macro).to eq(:has_many)
  end

  it "is invalid without :name" do
    expect(FactoryGirl.build(:site, name: nil)).not_to be_valid
  end

end
