class Phase < ActiveRecord::Base
  attr_accessible :name, :culture_id
  belongs_to :culture
  has_many :samples
  acts_as_list
end
