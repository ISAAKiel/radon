json.array!(@cultures) do |culture|
  json.extract! culture, :id, :name, :position
  json.url culture_url(culture, format: :json)
end
