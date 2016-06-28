atom_feed do |feed|
  feed.title "Radon Announcements"
  feed.updated @announcements.maximum(:updated_at)
  
  @announcements.each do |article|
    feed.entry article, published: article.created_at do |entry|
      entry.title article.title
      entry.content article.content
    end
  end
end
