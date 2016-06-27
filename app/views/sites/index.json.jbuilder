json.array!(@sites) do |site|
  json.extract! site, :id, :name, :parish, :district, :country_subdivision_id, :lat, :lng
  json.url site_url(site, format: :json)
end
