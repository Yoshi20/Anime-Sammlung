class RatingsController < ApplicationController
  before_action :set_rating, only: [:update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  after_action :update_anime_rating, only: [:create, :update]
  before_action { @section = 'ratings' }

  # POST /ratings
  def create
    if params[:rating].present?
      if params[:anime_id].present?
        a_id = params[:anime_id].to_i
        r_val = params[:rating].to_i
        new_rating = Rating.create({anime_id: a_id, user: current_user, rating: r_val})
        flash[:success] = "Your rating for '#{new_rating.anime.name}' has been saved."
      else
        flash[:alert] = "There's no Anime id! :,O"
      end
    else
      flash[:alert] = "You have to choose a rating to rate!"
    end
    redirect_to animes_path
  end

  # PATCH/PUT /ratings/1
  def update
    if params[:rating].present?
      r = Rating.find_by(anime: @rating.anime, user: current_user)
      r.rating = params[:rating].to_i
      r.save
      flash[:success] = "Your rating for '#{@rating.anime.name}' has been updated."
    else
      flash[:alert] = "To rate for '#{@rating.anime.name}' choose a rating first!"
    end
    redirect_to animes_path
  end

  # DELETE /ratings/1
  def destroy
    anime = @rating.anime
    @rating.destroy
    anime.update({rating: anime.average_rating})
    flash[:notice] = "Your rating for '#{@rating.anime.name}' has been deleted."
    redirect_to anime_path(anime)
  end

  private

    def set_rating
      @rating = Rating.find(params[:id])
    end

    def update_anime_rating
      anime = @rating.nil? ? Anime.last : @rating.anime
      anime.update({rating: anime.average_rating})
    end

end
