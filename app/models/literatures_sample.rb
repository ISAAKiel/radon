class LiteraturesSample < ActiveRecord::Base
  belongs_to :literature
  belongs_to :sample
end
