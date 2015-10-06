json.array!(@animes) do |anime|
  json.extract! anime, :id, :name, :genre, :episodes, :finished, :description, :rating
  json.url anime_url(anime, format: :json)
end
