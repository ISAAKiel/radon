class Right < ActiveRecord::Base
  attr_accessible :name

  has_many :samples

  validates_presence_of :name
  validates_uniqueness_of :name
end
