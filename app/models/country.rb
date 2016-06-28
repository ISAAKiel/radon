class Country < ActiveRecord::Base
  attr_accessible :name, :country_subdivisions_attributes, :abreviation

  has_many :country_subdivisions

  acts_as_list

  accepts_nested_attributes_for :country_subdivisions, :allow_destroy => true

  validates_presence_of :name
  validates_uniqueness_of :name
end
