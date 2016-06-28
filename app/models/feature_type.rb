class FeatureType < ActiveRecord::Base
  attr_accessible :name, :comment

  has_many :samples

  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name
end
