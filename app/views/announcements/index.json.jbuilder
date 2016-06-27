json.array!(@announcements) do |announcement|
  json.extract! announcement, :id, :title, :content
  json.url announcement_url(announcement, format: :json)
end
