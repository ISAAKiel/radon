json.array!(@literatures_samples) do |literatures_sample|
  json.extract! literatures_sample, :id, :literature_id, :sample_id, :pages
  json.url literatures_sample_url(literatures_sample, format: :json)
end
