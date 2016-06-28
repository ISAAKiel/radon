class Prmat < ActiveRecord::Base
  attr_accessible :name

  has_many :samples

  acts_as_list
  
  validates_presence_of :name
  validates_uniqueness_of :name

  def self.label
    "Sample material"
  end
end
