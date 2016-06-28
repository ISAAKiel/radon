class CountrySubdivision < ActiveRecord::Base
  attr_accessible :name, :country_id

  belongs_to :country
  has_many :sites

  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :country_id
end
