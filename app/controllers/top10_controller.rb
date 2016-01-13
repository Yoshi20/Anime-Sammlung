class Top10Controller < ApplicationController
	before_action { @section = 'top10' }

  # GET /top10
  # GET /top10.json
  def index
    @animes = Anime.includes(:genres).joins(:ratings).merge(Rating.all.order(rating: :desc)).limit(10)
  end

end
