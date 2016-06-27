json.array!(@rights) do |right|
  json.extract! right, :id, :name, :position
  json.url right_url(right, format: :json)
end
