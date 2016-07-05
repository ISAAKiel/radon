namespace :db do
  desc "Erase and fill database with public radon data"
  task :populate => :environment do
   
    [Country, CountrySubdivision, Culture, Phase, FeatureType, Lab, Prmat, Site, Literature, LiteraturesSample, Sample].each(&:delete_all)
    
    require 'csv'

    puts "Importing Countries"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'countries.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Country.new
      t.id = row['id']
      t.name = row['name']
      t.position = row['position']
      t.abreviation = row['abreviation']
      collector << t
    end
    Country.import collector, validate: false
    puts "There are now #{Country.count} rows in the countries table"

    puts "Importing CountrySubdivisions"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'country_subdivisions.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = CountrySubdivision.new
      t.id = row['id']
      t.name = row['name']
      t.country_id = row['country_id']
      t.position = row['position']
      collector << t
    end
    CountrySubdivision.import collector, validate: false
    puts "There are now #{CountrySubdivision.count} rows in the country subdivision table"

    puts "Importing Cultures"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'cultures.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Culture.new
      t.id = row['id']
      t.name = row['name']
      t.position = row['position']
      collector << t
    end
    Culture.import collector, validate: false
    puts "There are now #{Culture.count} rows in the culture table"

    puts "Importing Phases"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'phases.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Phase.new
      t.id = row['id']
      t.name = row['name']
      t.culture_id = row['culture_id']
      t.position = row['position']
      t.approved = row['approved']
      collector << t
    end
    Phase.import collector, validate: false
    puts "There are now #{Phase.count} rows in the phases table"

    puts "Importing Feature Types"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'feature_types.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = FeatureType.new
      t.id = row['id']
      t.name = row['name']
      t.comment = row['comment']
      t.position = row['position']
      collector << t
    end
    FeatureType.import collector, validate: false
    puts "There are now #{FeatureType.count} rows in the Feature Types table"

    puts "Importing Labs"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'labs.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Lab.new
      t.id = row['id']
      t.name = row['name']
      t.dating_method_id = row['dating_method_id']
      t.lab_code = row['lab_code']
      t.position = row['position']
      t.country = row['country']
      t.active = row['active']
      collector << t
    end
    Lab.import collector, validate: false
    puts "There are now #{Lab.count} rows in the Labs table"

    puts "Importing Sample Materials"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'prmats.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Prmat.new
      t.id = row['id']
      t.name = row['name']
      t.position = row['position']
      collector << t
    end
    Prmat.import collector, validate: false
    puts "There are now #{Prmat.count} rows in the Sample Materials table"

    puts "Importing Sites"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'sites.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Site.new
      t.id = row['id']
      t.name = row['name']
      t.parish = row['parish']
      t.district = row['district']
      t.country_subdivision_id = row['country_subdivision_id']
      t.lat = row['lat']
      t.lng = row['lng']
      collector << t
    end
    Site.import collector, validate: false
    puts "There are now #{Site.count} rows in the Sites table"

    puts "Importing Literature"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'literatures.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Literature.new
      t.id = row['id']
      t.short_citation = row['short_citation']
      t.year = row['year']
      t.author = row['author']
      t.long_citation = row['long_citation']
      t.url = row['url']
      t.approved = row['approved']
      t.bibtex = row['bibtex']
      collector << t
    end
    Literature.import collector, validate: false
    puts "There are now #{Literature.count} rows in the Literature table"

    puts "Importing literatures_samples join table"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'literatures_samples.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = LiteraturesSample.new
      t.id = row['id']
      t.literature_id = row['literature_id']
      t.sample_id = row['sample_id']
      t.pages = row['pages']
      collector << t
    end
    LiteraturesSample.import collector, validate: false
    puts "There are now #{LiteraturesSample.count} rows in the literatures_samples join table"

    puts "Importing Samples"
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'samples.csv'))
    csv = CSV.parse(csv_text, :headers => true, :encoding => 'UTF-8')
    collector = []
    csv.each do |row|
      t = Sample.new
      t.id = row['id']
      t.lab_id = row['lab_id']
      t.lab_nr = row['lab_nr']
      t.bp = row['bp']
      t.std = row['std']
      t.delta_13_c = row['delta_13_c']
      t.delta_13_c_std = row['delta_13_c_std']
      t.prmat_id = row['prmat_id']
      t.prmat_comment = row['prmat_comment']
      t.comment = row['comment']
      t.feature = row['feature']
      t.feature_type_id = row['feature_type_id']
      t.phase_id = row['phase_id']
      t.site_id = row['site_id']
      t.approved = row['approved']
      t.right_id = row['right_id']
      t.dating_method_id = row['dating_method_id']
      collector << t
    end
    Sample.import collector, validate: false
    puts "There are now #{Sample.count} rows in the Samples table"
  end
end
