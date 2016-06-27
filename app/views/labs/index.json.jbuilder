json.array!(@labs) do |lab|
  json.extract! lab, :id, :name, :dating_method_id, :lab_code, :country, :active, :position
  json.url lab_url(lab, format: :json)
end
