json.array!(@animes) do |anime|
  json.extract! anime, :id, :name, :episodes, :finished, :description, :comment, :rating
  json.url anime_url(anime, format: :json)
end
