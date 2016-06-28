class Culture < ActiveRecord::Base
  attr_accessible :name, :phases_attributes

  has_many :phases

  has_many :samples, :through=>:phase

  acts_as_list

  accepts_nested_attributes_for :phases, :allow_destroy => true
end
