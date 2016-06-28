class Page < ActiveRecord::Base
  attr_accessible :name, :content
  
  acts_as_list
  
  validates_uniqueness_of :name
  validates_presence_of :name, :content
end
