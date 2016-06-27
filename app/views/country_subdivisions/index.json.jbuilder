json.array!(@country_subdivisions) do |country_subdivision|
  json.extract! country_subdivision, :id, :name, :position, :country_id
  json.url country_subdivision_url(country_subdivision, format: :json)
end
