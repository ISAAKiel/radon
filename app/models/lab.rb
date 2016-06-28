class Lab < ActiveRecord::Base
  attr_accessible :name, :dating_method_id, :lab_code, :country, :active

  has_many :samples
  belongs_to :dating_method

  acts_as_list

  validates_presence_of :name, :lab_code
  validates_uniqueness_of :name, :lab_code
  
  def self.label
    "Laboratory"
  end
end
