class AnimesController < ApplicationController
  before_action :set_anime, only: [:show, :edit, :update, :destroy]
  before_action :get_genres, only: [:index, :new, :edit, :create]
  before_action :authenticate_user!, only: [:edit, :create, :update, :destroy]
  before_action { @section = 'animes' }

  # GET /animes
  # GET /animes.json
  def index
    # get animes
    @animes = Anime.includes(:genres, :ratings).all

    if @animes.empty?
      flash.now[:alert] = "There are no Animes to list."
    else
      # handle search (self written method)
      if params[:search].present?
        @animes = @animes.search(params[:search])
        if @animes.empty?
          flash.now[:alert] = "There were no Animes found with this search query."
        end
      end

      # handle params to limit selected animes
      if params[:order_by_letter].present?
        if params[:order_by_letter] == '#'
          # Get all animes which starts NOT with 'A'..'Z'
          a = []
          ('A'..'Z').each do |letter|
            a << Anime.where("name LIKE ?", "#{letter}%").map(&:id)
          end
          a = a.flatten
          @animes = @animes.where.not(id: a)
           if @animes.empty?
            flash.now[:alert] = "There are no Animes that begin with a special character."
          end
        else
          @animes = @animes.where('animes.name LIKE ?', "#{params[:order_by_letter]}%")
          if @animes.empty?
            flash.now[:alert] = "There are no Animes that begin with the letter '#{params[:order_by_letter]}'."
          end
        end
      end

      if params[:genre_id].present?
        @animes = @animes.joins(:genres).where(genres: {id: params[:genre_id].to_i})
        if @animes.empty?
          flash.now[:alert] = "There are no Animes with the genre '#{Genre.find(params[:genre_id].to_i).name}'."
        end
      end

      # handle parameters to sort and order
      if params[:sort].present?
        if params[:sort] == 'genres'
          @animes = @animes.joins(:genres).merge(Genre.order("genres.name"))
        elsif params[:sort] == 'number_of_ratings'
          #blup: TODO -> number_of_ratings & my_ratings korrigieren/verbessern
          @animes = Anime.joins(:ratings).merge(Rating.group("ratings.anime_id").order("count(ratings.anime_id)")).where(id: @animes)
        elsif params[:sort] == 'my_rating'
          @animes = Anime.joins(:ratings).merge(Rating.where(user_id: current_user).order("ratings.rating")).order(:name)
        elsif params[:sort] == 'episodes'
          #blup: TODO -> episodes + ova_episodes
          # a = @animes.map{|a| [{id: a.id, episodes: a.episodes + (a.ova_episodes || 0)}]}
          # a = a.sort_by{|i| i[0][:episodes]}
          @animes = @animes.order("animes.episodes")
        else
          @animes = @animes.order("animes.#{params[:sort]}")
        end
      else
        @animes = @animes.order('animes.name')
      end

      if params[:order] == "desc"
        @animes = @animes.reverse_order
      end

      # paginate animes (have to be called last)
      @animes = @animes.paginate(page: params[:page], per_page: get_number_of_items_per_page)
    end

    # handle ajax request
    respond_to do |format|
      format.json {
        animes_html = render_to_string(partial: @animes, formats: [:html]).html_safe
        url_params = ""
        table_params.each{|k,v| url_params << "#{k}=#{v}&"}
        render json: {
          status: 'success',
          animes: animes_html,
          params: url_params[0..-2] # to cut off the last '&'
        }, status: :ok
      }
      format.html
    end

  end

  # GET /animes/1
  # GET /animes/1.json
  def show

  end

  # GET /animes/new
  def new
    @anime = Anime.new
  end

  # GET /animes/1/edit
  def edit

  end

  # POST /animes
  # POST /animes.json
  def create
    @anime = Anime.new(anime_params)
    @anime.user = current_user
    respond_to do |format|
      if @anime.save
        unless @anime.rating == 0
          Rating.create({anime_id: @anime.id, user_id: current_user.try(:id), rating: @anime.rating})
        end
        format.html { redirect_to @anime, notice: 'Anime was successfully created.' }
        format.json { render :show, status: :created, location: @anime }
      else
        format.html { render :new }
        format.json { render json: @anime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animes/1
  # PATCH/PUT /animes/1.json
  def update
    anime_params.delete(:rating) # do not allow a new rating
    respond_to do |format|
      if @anime.update(anime_params)
        if @anime.user != current_user
          UserMailer::anime_changed_notification_mail(@anime, current_user).deliver_later
        end
        format.html { redirect_to @anime, notice: 'Anime was successfully updated.' }
        format.json { render :show, status: :ok, location: @anime }
      else
        get_genres()
        format.html { render :edit }
        format.json { render json: @anime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animes/1
  # DELETE /animes/1.json
  def destroy
    @anime.destroy
    respond_to do |format|
      format.html { redirect_to animes_url, notice: 'Anime was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # import /animes/import
  def import
    warnings = Anime.import(params[:file], current_user)
    puts warnings.inspect if warnings.length > 0
    redirect_to root_url, notice: "Animes imported"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anime
      @anime = Anime.find(params[:id])
    end

    def get_genres
      @genres = Genre.all.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def anime_params
      params.require(:anime).permit(:name, :episodes, :ova_episodes, :special_episodes, :finished, :description, :comment, :rating, { genre_ids: []})
    end

    def table_params
      params.permit(:page, :sort, :order, :order_by_letter, :genre_id, :search)
    end
end
