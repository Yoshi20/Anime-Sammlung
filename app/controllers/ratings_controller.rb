class RatingsController < ApplicationController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  after_action :set_anime_rating, only: [:create, :update]
  before_action { @section = 'raitings' }
  
  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.includes[:animes, :users].all
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
    puts params
  end

  # GET /ratings/new
  def new
    @rating = Rating.new

  end

  # GET /ratings/1/edit
  def edit

  end

  # POST /ratings
  # POST /ratings.json
  def create
    if params[:rating].present?
      if params[:anime_id].present?
        a_id = params[:anime_id]
        r_val = params[:rating]
        new_rating = Rating.create({anime_id:a_id, user:current_user, rating:r_val})

        flash[:success] = "Your rating for '#{new_rating.anime.name}' has been saved"

      else
        flash[:alert] = "There's no Anime id! :,O"
      end

    else
      flash[:alert] = "You have to choose a rating to rate!"
    end
    
    redirect_to animes_path

  end

  # PATCH/PUT /ratings/1
  # PATCH/PUT /ratings/1.json
  def update
    if params[:rating].present?
      r = Rating.find_by(anime:@rating.anime, user:current_user)
      r.rating = params[:rating]
      r.save

      flash[:success] = "Your rating for '#{@rating.anime.name}' has been updated"
    else
      flash[:alert] = "To rate for '#{@rating.anime.name}' choose a rating first!"
    end

    redirect_to animes_path

  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating.destroy
    respond_to do |format|
      format.html { redirect_to animes_url, notice: 'Rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    def set_anime_rating
      anime = @rating.nil? ? Anime.last : @rating.anime
      anime.rating = anime.average_rating
      anime.save
    end

end
