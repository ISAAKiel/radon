class Site < ActiveRecord::Base
  attr_accessible :name, :parish, :district, :country_subdivision_id, :samples_attributes, :lat, :lng

  validates_presence_of :name, :lat, :lng

  belongs_to :country_subdivision
  has_many :samples

  accepts_nested_attributes_for :samples, :allow_destroy => true

  def self.propose_locations(search)
    require 'iconv'
    unless search.blank?
#      search_string = Iconv.iconv('ascii//translit', 'utf-8', CGI.unescape(search)).to_s
      search_string = CGI.unescape(search).force_encoding('UTF-8')
      url = "http://ws.geonames.org" + "/searchJSON?a=a"
      url = url + "&name=#{search_string.downcase}&username=radon"
      uri = URI.parse(URI.escape(url))
      req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
      res = Net::HTTP.start( uri.host, uri.port ) { |http|
        http.request( req )
      }
      doc = ActiveSupport::JSON.decode(res.body)
      doc
    end
  end
end
