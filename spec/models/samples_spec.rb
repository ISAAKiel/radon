require 'spec_helper'

describe "Samples" do

  it "has a valid factory" do
    expect(FactoryGirl.build(:sample)).to be_valid
  end

  it "should have accessible :lab_id" do
    expect { Sample.new(lab_id: 12) }.not_to raise_error
  end

  it "should have accessible :lab_nr" do
    expect { Sample.new(lab_nr: 'lab_nr') }.not_to raise_error
  end

  it "should have accessible :bp" do
    expect { Sample.new(bp: '12') }.not_to raise_error
  end

  it "should have accessible :std" do
    expect { Sample.new(std: '12') }.not_to raise_error
  end

  it "should have accessible :delta_13_c" do
    expect { Sample.new(delta_13_c: 12) }.not_to raise_error
  end

  it "should have accessible :delta_13_c_std" do
    expect { Sample.new(delta_13_c_std: 12) }.not_to raise_error
  end

  it "should have accessible :prmat_id" do
    expect { Sample.new(prmat_id: 12) }.not_to raise_error
  end

  it "should have accessible :prmat_comment" do
    expect { Sample.new(prmat_comment: 'prmat_comment') }.not_to raise_error
  end

  it "should have accessible :comment" do
    expect { Sample.new(comment: '12') }.not_to raise_error
  end

  it "should have accessible :feature" do
    expect { Sample.new(feature: 'feature') }.not_to raise_error
  end

  it "should have accessible :feature_type_id" do
    expect { Sample.new(feature_type_id: 12) }.not_to raise_error
  end

  it "should have accessible :phase_id" do
    expect { Sample.new(phase_id: 12) }.not_to raise_error
  end

  it "should have accessible :site_id" do
    expect { Sample.new(site_id: 12) }.not_to raise_error
  end

  it "should have accessible :approved" do
    expect { Sample.new(approved: true) }.not_to raise_error
  end

  it "should have accessible :right_id" do
    expect { Sample.new(right_id: 12) }.not_to raise_error
  end

  it "should have accessible :dating_method_id" do
    expect { Sample.new(dating_method_id: 12) }.not_to raise_error
  end

  it "should have accessible :literatures_attributes"

  it "should have accessible :literatures_samples_attributes"

  it "should have many :comments" do
    t = Sample.reflect_on_association(:comments)
    expect(t.macro).to eq(:has_many)
  end

  it "should belong_to :prmat" do
    t = Sample.reflect_on_association(:prmat)
    expect(t.macro).to eq(:belongs_to)
  end

  it "should belong_to :feature_type" do
    t = Sample.reflect_on_association(:feature_type)
    expect(t.macro).to eq(:belongs_to)
  end

  it "should belong_to :right" do
    t = Sample.reflect_on_association(:right)
    expect(t.macro).to eq(:belongs_to)
  end

  it "should belong_to :site" do
    t = Sample.reflect_on_association(:site)
    expect(t.macro).to eq(:belongs_to)
  end

  it "should belong_to :phase" do
    t = Sample.reflect_on_association(:phase)
    expect(t.macro).to eq(:belongs_to)
  end

  it "should belong_to :lab" do
    t = Sample.reflect_on_association(:lab)
    expect(t.macro).to eq(:belongs_to)
  end

  it "is invalid without :lab_nr" do
    expect(FactoryGirl.build(:sample, lab_nr: nil)).not_to be_valid
  end

  it "is invalid without :bp" do
    expect(FactoryGirl.build(:sample, bp: nil)).not_to be_valid
  end

  it "is invalid without :std" do
    expect(FactoryGirl.build(:sample, std: nil)).not_to be_valid
  end

  it "is invalid without :prmat" do
    expect(FactoryGirl.build(:sample, prmat: nil)).not_to be_valid
  end

  it "is invalid without :feature_type" do
    expect(FactoryGirl.build(:sample, feature_type: nil)).not_to be_valid
  end

  it "is invalid without :right" do
    expect(FactoryGirl.build(:sample, right: nil)).not_to be_valid
  end

  it "is invalid without :site" do
    expect(FactoryGirl.build(:sample, site: nil)).not_to be_valid
  end

  it "is invalid without :phase" do
    expect(FactoryGirl.build(:sample, phase: nil)).not_to be_valid
  end

  it "is invalid without :lab" do
    expect(FactoryGirl.build(:sample, lab: nil)).not_to be_valid
  end

  it "should convert delta_13_c from german to english float" do
    expect(FactoryGirl.build(:sample, delta_13_c: '12,13').delta_13_c).to eq(12.13)
  end

  it "should convert delta_13_c_std from german to english float" do
    expect(FactoryGirl.build(:sample, delta_13_c_std: '12,13').delta_13_c_std).to eq(12.13)
  end

  it "should return a name from lab_code and lab_nr" do
    s = FactoryGirl.build(:sample)
    expect(s.name).to eq((s.lab.lab_code rescue "") + "-" + s.lab_nr)
  end

  it "should return human_attribute_names" do
    expect(Sample.human_attribute_name(:prmat)).to be_an_instance_of(String)
  end

  it "should return hint_texts" do
    expect(Sample.hint_text(:prmat)).to be_an_instance_of(String)
  end
end
