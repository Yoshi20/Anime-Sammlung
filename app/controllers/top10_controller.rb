class Top10Controller < ApplicationController
	before_action { @section = 'top10' }

  # GET /top10
  # GET /top10.json
  def index
    @animes = Anime.includes(:target_audience, :genres).order(:rating)
    @animes = @animes.joins(:ratings).merge(Rating.group("animes.id, ratings.anime_id").order("count(ratings.anime_id)"))
    @animes = @animes.order(name: :desc).reverse_order.limit(10)
  end

end

# Fehlerhafte Queries:
# @animes = @animes.joins(:ratings).group("animes.id, ratings.rating").order("count(ratings.rating) asc")
