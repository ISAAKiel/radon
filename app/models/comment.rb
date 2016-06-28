class Comment < ActiveRecord::Base
  attr_accessible :comment, :user_id, :sample_id

  belongs_to :sample
  belongs_to :user
end
