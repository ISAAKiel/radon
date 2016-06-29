require 'rails_helper'

describe "DatingMethods" do
  it "has a valid factory" do
    expect(FactoryGirl.build(:dating_method)).to be_valid
  end
  it "should act_as_list" do
    expect(FactoryGirl.build(:dating_method)).to respond_to(:move_to_top)
  end
  it "should have accessible :name" do
    expect { DatingMethod.new(name: 'name') }.not_to raise_error
  end
  it "should have many :samples" do
    t = DatingMethod.reflect_on_association(:samples)
    expect(t.macro).to eq(:has_many)
  end

  it "should have many :labs" do
    t = DatingMethod.reflect_on_association(:labs)
    expect(t.macro).to eq(:has_many)
  end

  it "is invalid without :name" do
    expect(FactoryGirl.build(:dating_method, name: nil)).not_to be_valid
  end

  it "does not allow duplicate :name" do
    FactoryGirl.create(:dating_method, name: "1")
    expect(FactoryGirl.build(:dating_method, name: "1")).not_to be_valid
  end
end
