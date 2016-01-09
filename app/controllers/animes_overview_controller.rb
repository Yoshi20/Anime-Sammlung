class AnimesOverviewController < ApplicationController
  before_action { @section = 'animes_overview' }

  # GET /animes_overview
  def index
    @animes = Anime.all

    if user_signed_in?
      @rated_animes = Rating.where(user_id: current_user).where("rating > 0 and rating is not null").map(&:anime_id)
    end
  end

end
