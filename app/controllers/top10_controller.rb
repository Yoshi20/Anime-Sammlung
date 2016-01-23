class Top10Controller < ApplicationController
	before_action { @section = 'top10' }

  # GET /top10
  # GET /top10.json
  def index
    @animes = Anime.includes(:target_audience, :genres, :ratings).order(:rating, name: :desc).reverse_order.limit(10)
  end

end
