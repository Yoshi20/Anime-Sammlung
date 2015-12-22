class AnimesController < ApplicationController
  before_action :set_anime, only: [:show, :edit, :update, :destroy]
  before_action :get_genres, only: [:index, :new, :edit, :create]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action { @section = 'animes' }

  # GET /animes
  # GET /animes.json
  def index
    # get animes
    @animes = Anime.includes(:genres, :ratings).all

    puts ''
    puts 'Params:'
    puts params.inspect
    puts ''

    if @animes.empty?
      flash.now[:alert] = "There are no Animes to list."
    else
      # handle search (self written method)
      if params[:search].present?
        @animes = @animes.search(params[:search])
      end

      # handle params to limit selected animes
      if params[:order_by_letter].present?
        @animes = @animes.where('animes.name LIKE ?', "#{params[:order_by_letter]}%")
        if @animes.empty?
          flash.now[:alert] = "There are no Animes that begin with the letter #{params[:order_by_letter]}"
        end
      end

      if params[:genre_id].present?
        @animes = @animes.joins(:genres).where(genres: {id: params[:genre_id].to_i})
        if @animes.empty?
          flash.now[:alert] = "There are no Animes with the genre #{@genres.find(params[:genre_id]).name}."
        end
      end

      # handle parameters to sort and order
      if params[:sort].present?
        @animes = @animes.order(params[:sort].to_s)
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
        animes_html = render_to_string(partial: @animes, formats: [:html], locals: {animes: @animes}).html_safe
        pagination_html = render_to_string(partial: 'paginator', formats: [:html], locals: {animes: @animes}).html_safe
        render json: {
          status: 'success',
          animes: animes_html,
          pagination: pagination_html,
        }, status: :ok
      }
      format.html
    end

  end

  # GET /animes/1
  # GET /animes/1.json
  def show
    puts params
  end  # renders app/views/animes/show.html.erb automatically

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

    respond_to do |format|
      if @anime.save
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
    respond_to do |format|
      if @anime.update(anime_params)
        format.html { redirect_to @anime, notice: 'Anime was successfully updated.' }
        format.json { render :show, status: :ok, location: @anime }
      else
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
    Anime.import(params[:file])
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
      params.require(:anime).permit(:name, :episodes, :finished, :rating, { genre_ids: []})
    end
end
