class Sample < ActiveRecord::Base
  belongs_to :lab
  belongs_to :prmat
  belongs_to :feature_type
  belongs_to :phase
  belongs_to :site
  belongs_to :right
  belongs_to :dating_method
end
