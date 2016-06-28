require 'spec_helper'

describe "Labs" do

  it "has a valid factory" do
    expect(FactoryGirl.build(:lab)).to be_valid
  end
  it "has a valid factory also for samples"

  it "should act_as_list" do
    expect(FactoryGirl.build(:lab)).to respond_to(:move_to_top)
  end

  it "should have accessible :name" do
    expect { Lab.new(name: 'name') }.not_to raise_error
  end

  it "should have accessible :lab_code" do
    expect { Lab.new(lab_code: 'lab_code') }.not_to raise_error
  end

  it "should have accessible :dating_method_id" do
    expect { Lab.new(dating_method_id: 'dating_method_id') }.not_to raise_error
  end

  it "should have many :samples" do
    t = Lab.reflect_on_association(:samples)
    expect(t.macro).to eq(:has_many)
  end

  it "is invalid without :name" do
    expect(FactoryGirl.build(:lab, name: nil)).not_to be_valid
  end

  it "is invalid without :lab_code" do
    expect(FactoryGirl.build(:lab, lab_code: nil)).not_to be_valid
  end

  it "does not allow duplicate :name" do
    FactoryGirl.create(:lab, name: "1")
    expect(FactoryGirl.build(:lab, name: "1")).not_to be_valid
  end
end
