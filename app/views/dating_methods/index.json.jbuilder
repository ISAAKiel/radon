json.array!(@dating_methods) do |dating_method|
  json.extract! dating_method, :id, :name, :position
  json.url dating_method_url(dating_method, format: :json)
end
