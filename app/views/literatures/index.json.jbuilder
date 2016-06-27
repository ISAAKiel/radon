json.array!(@literatures) do |literature|
  json.extract! literature, :id, :short_citation, :year, :author, :long_citation, :url, :approved, :bibtex
  json.url literature_url(literature, format: :json)
end
