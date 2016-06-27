json.array!(@feature_types) do |feature_type|
  json.extract! feature_type, :id, :name, :comment, :position
  json.url feature_type_url(feature_type, format: :json)
end
