class LiteraturesSample < ActiveRecord::Base

attr_accessible :literature_short_citation_autocomplete, :pages, :literature, :literature_attributes, :literature_id

belongs_to :sample
belongs_to :literature

  accepts_nested_attributes_for :literature
  accepts_nested_attributes_for :sample
  
  attr_accessor :literature_short_citation_autocomplete

  def sample_name
    sample.name
  end
  
  def literature_name
    try(literature.name)
  end

  def literature_short_citation
#    try(literature.short_citation) if literature
  end

  def literature_short_citation=(literature_short_citation)
#    self.literature = Literature.where(short_citation: literature_short_citation) if literature_short_citation.present?
  end
end
