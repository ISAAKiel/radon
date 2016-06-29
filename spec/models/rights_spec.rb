require 'rails_helper'

describe "Rights" do
  it "has a valid factory" do
    expect(FactoryGirl.build(:right)).to be_valid
  end

  it "should have accessible :name" do
    expect { Right.new(name: 'name') }.not_to raise_error
  end

  it "should have many :samples" do
    t = Right.reflect_on_association(:samples)
    expect(t.macro).to eq(:has_many)
  end

  it "is invalid without :name" do
    expect(FactoryGirl.build(:right, name: nil)).not_to be_valid
  end

  it "does not allow duplicate :name" do
    FactoryGirl.create(:right, name: "1")
    expect(FactoryGirl.build(:right, name: "1")).not_to be_valid
  end
end
