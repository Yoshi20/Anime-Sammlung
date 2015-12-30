class RandomAnimesController < ApplicationController
  before_action { @section = 'random_anime' }

  # GET /random_anime
  def show
    @anime = Anime.order("RANDOM()").first
    render 'animes/show'
  end

end
