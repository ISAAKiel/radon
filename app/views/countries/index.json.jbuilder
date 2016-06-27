json.array!(@countries) do |country|
  json.extract! country, :id, :name, :position, :abreviation
  json.url country_url(country, format: :json)
end
