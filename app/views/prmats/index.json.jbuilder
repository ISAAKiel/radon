json.array!(@prmats) do |prmat|
  json.extract! prmat, :id, :name, :position
  json.url prmat_url(prmat, format: :json)
end
