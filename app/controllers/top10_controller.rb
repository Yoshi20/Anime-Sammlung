class Top10Controller < ApplicationController
	before_action { @section = 'top10' }

  # GET /top10
  # GET /top10.json
  def index
    @animes = Anime.includes(:genres, :ratings).order(:rating).reverse_order.limit(10)
  end

end
