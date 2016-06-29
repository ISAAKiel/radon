require 'rails_helper'

describe "CountrySubdivisionSubdivisions" do
  it "has a valid factory" do
    expect(FactoryGirl.build(:country_subdivision)).to be_valid
  end
  it "should act_as_list" do
    expect(FactoryGirl.build(:country_subdivision)).to respond_to(:move_to_top)
  end
  it "should have accessible :name" do
    expect { CountrySubdivision.new(name: 'name') }.not_to raise_error
  end

  it "should have many :sites" do
    t = CountrySubdivision.reflect_on_association(:sites)
    expect(t.macro).to eq(:has_many)
  end

  it "should belong_to :country" do
    t = CountrySubdivision.reflect_on_association(:country)
    expect(t.macro).to eq(:belongs_to)
  end

  it "is invalid without :name" do
    expect(FactoryGirl.build(:country_subdivision, name: nil)).not_to be_valid
  end

  it "does allow duplicate :name at different countries" do
    FactoryGirl.create(:country_subdivision, name: "1", country_id: "1")
    expect(FactoryGirl.build(:country_subdivision, name: "1", country_id: "2")).to be_valid
  end

  it "does not allow duplicate :name at the same country" do
    FactoryGirl.create(:country_subdivision, name: "1", country_id: "1")
    expect(FactoryGirl.build(:country_subdivision, name: "1", country_id: "1")).not_to be_valid
  end
end
