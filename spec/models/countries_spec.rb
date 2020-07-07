require 'rails_helper'

describe "Countries" do
  it "has a valid factory" do
    expect(FactoryBot.build(:country)).to be_valid
  end
  it "should act_as_list" do
    expect(FactoryBot.build(:country)).to respond_to(:move_to_top)
  end
  it "should have accessible :name" do
    expect { Country.new(name: 'name') }.not_to raise_error
  end

  it "should have many :country_subdivisions" do
    t = Country.reflect_on_association(:country_subdivisions)
    expect(t.macro).to eq(:has_many)
  end

  it "is invalid without :name" do
    expect(FactoryBot.build(:country, name: nil)).not_to be_valid
  end

  it "does not allow duplicate :name" do
    FactoryBot.create(:country, name: "1")
    expect(FactoryBot.build(:country, name: "1")).not_to be_valid
  end

  it "accepts nested attributes for CountrySubdivision"
end
