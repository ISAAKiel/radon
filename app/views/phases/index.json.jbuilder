json.array!(@phases) do |phase|
  json.extract! phase, :id, :name, :culture_id, :approved, :position
  json.url phase_url(phase, format: :json)
end
