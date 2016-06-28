class Literature < ActiveRecord::Base
  attr_accessible :short_citation, :year, :author, :long_citation, :url, :bibtex, :literatures_samples_attributes

  has_many :literatures_samples
  has_many :samples, :through => :literatures_samples

#  accepts_nested_attributes_for :samples
  accepts_nested_attributes_for :literatures_samples, :allow_destroy => true

  before_save do
    unless self.bibtex.blank?
      if self.author.blank?
        self.make_author_from_bibtex
      end
      if self.year.blank?
        self.make_year_from_bibtex
      end
      if self.long_citation.blank?
        self.make_long_citation_from_bibtex
      end
      if self.short_citation.blank?
        self.make_short_citation_from_bibtex
      end
    end
  end

  def name
    short_citation
  end
  
  def self.find_all_by_name(search_name)
    temps = Literature.all
    temps.find_all {|temp| temp.name.include? search_name}
  end

  def to_bibtex
    bibtex || "@article{#{id}," +
               "title    = {#{long_citation}}," +
               "author   = {#{author}}," +
               "year     = {#{year}}" +
               "}"
  end

  def make_author_from_bibtex
    bib_object = BibTeX.parse(bibtex).first
    authors = bib_object[:author].to_s
    unless authors.blank?
      self.author=authors.to_s
    end
  end

  def make_year_from_bibtex
    bib_object = BibTeX.parse(bibtex).first
    year = bib_object[:year]
    unless year.blank?
      self.year=year.to_s
    end
  end

  def make_short_citation_from_bibtex
    bib_object = BibTeX.parse(bibtex).first
    year = bib_object[:year]
    author = bib_object[:author]
    if year.blank? 
      year="without year"
    end
    if author.blank? 
      short_citation = "without author" + " " + year.to_s
    elsif author.length==1
      short_citation = author.first.last.to_s + " " + year.to_s
    elsif author.length==2
      short_citation = author[0].last.to_s + "/" + author[1].last.to_s + " " + year.to_s
    else
      short_citation = author.first.last.to_s + " et al. " + year.to_s
    end
    self.short_citation=short_citation.to_s
  end

  def make_long_citation_from_bibtex
    bib_object = BibTeX.parse(bibtex).first
    long_citation = bib_object[:title].to_s

    if bib_object.type == :article
      long_citation << ". " + bib_object[:journal].to_s unless bib_object[:journal].blank?
      long_citation << " " + bib_object[:volume].to_s unless bib_object[:volume].blank?
      long_citation << " / " + bib_object[:number].to_s unless bib_object[:number].blank?
      long_citation << ", " + bib_object[:year].to_s unless bib_object[:year].blank?
      long_citation << ", " + bib_object[:pages].to_s unless bib_object[:pages].blank?
    end

    if ((bib_object.type == :incollection) || (bib_object.type == :inbook))
      if bib_object[:editor].blank?
        long_citation << ". In: "
      elsif bib_object[:editor].length==1
        long_citation << ". In: " + bib_object[:editor].to_s + "(ed.)"
      elsif
        long_citation << ". In: " + bib_object[:editor].to_s + "(eds.)"
      end
      long_citation << ", " + bib_object[:booktitle].to_s unless bib_object[:booktitle].blank?
    end

    if ((bib_object.type == :book) || (bib_object.type == :inbook))
      long_citation << ". " + bib_object[:series].to_s unless bib_object[:series].blank?
      long_citation << " " + bib_object[:volume].to_s unless bib_object[:volume].blank?
      long_citation << " / " + bib_object[:number].to_s unless bib_object[:number].blank?
      long_citation << " (" + bib_object[:address].to_s + bib_object[:year].to_s  + ')' unless (bib_object[:address].blank? || bib_object[:year].blank?)
      long_citation << " (" + bib_object[:year].to_s  + ')' if bib_object[:year].present? && bib_object[:address].blank?
      long_citation << " (" + bib_object[:address].to_s  + ')' if bib_object[:address].present? && bib_object[:year].blank?
    end

    if bib_object.type == :inbook
      long_citation << " " + bib_object[:pages].to_s unless bib_object[:pages].blank?
    end

    long_citation << "."

    unless long_citation.blank?
      self.long_citation=long_citation.to_s
    end
  end
end
