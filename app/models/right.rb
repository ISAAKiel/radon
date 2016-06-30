class Right < ActiveRecord::Base
  attr_accessible :name, :id

  has_many :samples

  validates_presence_of :name
  validates_uniqueness_of :name
end
