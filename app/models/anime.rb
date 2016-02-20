class Anime < ActiveRecord::Base
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :target_audience
  belongs_to :user
  has_many :ratings, dependent: :destroy

  validates :name, :target_audience, :genres, :rating, presence: true
  validates :name, uniqueness: true, length: {maximum:50}
  validates :episodes, numericality: {greater_than: -1}
  validates :ova_episodes, numericality: {greater_than: -1}
  validates :special_episodes, numericality: {greater_than: -1}
  validates :rating, inclusion: {in: 0..6}

  MAX_RATING = 6
  MAX_ANIMES_PER_PAGE = 30

  # chia-anime image-url
  def image_path
    anime_image_path = 'animes/'
    anime_image_path += self.name.gsub(' ', '-').gsub('/', '').gsub('.', '').gsub(':', '-').gsub('%', '')
    anime_image_path += '.jpg'

    if File.file?('app/assets/images/' + anime_image_path)
      anime_image_path
    else
      'animes/_No_Photo_Available.jpg'
    end
  end

  # to add the name into the url
  def to_param
    "#{id} #{name}".parameterize
  end

  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    else
      :all
    end
  end

#import CSV
  # def self.import(file)
  #   warnings = {unbekannte_genres: []}
  #   CSV.foreach(file.path, headers:true) do |row|
  #     allowed_columns = %w(name genres episodes ova_episodes special_episodes finished description comment rating)
  #     attributes = row.to_hash.keep_if{|key, _value| allowed_columns.include?(key)}
  #     attributes["genres"] = attributes["genres"].split(" / ").map do |genre_name|
  #       genre = Genre.find_by(name: genre_name)
  #       if genre.present?
  #        genre
  #       else
  #         warnings[:unbekannte_genres] << genre_name
  #         nil
  #       end
  #     end.compact
  #     anime = Anime.find_by(name: attributes["name"])
  #     if anime.present?
  #       anime.update(attributes)
  #     else
  #       Anime.create!(attributes)
  #     end
  #   end
  #   warnings
  # end

#import XLS
  def self.import(file, user)
    permitted_columns = %w(name genres episodes ova_episodes special_episodes finished comment description rating)
    warnings = {updated_animes: [], new_genres: [], animes_without_a_genre: []}
    params_hash = {}

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open file.path
    sheet = book.worksheet 0 # use only the first worksheet

    # header (define params_hash_keys)
    sheet.row(0).each do |column|
      params_hash[column.downcase] = nil
    end
    # body
    sheet.each_with_index do |row, row_index|

      if row_index > 0

        #fill up params_hash with current row data
        permitted_columns.each_with_index do |c, i|
          params_hash[c] = row[i]
        end

        #anime
        anime_attributes = params_hash.except("genres")
        anime_attributes["rating"] = 0 if anime_attributes["rating"].nil?
        anime = Anime.find_by(name: anime_attributes["name"])
        if anime.present?
          anime.update!(anime_attributes)
          warnings[:updated_animes] << anime.name
        else
          anime = Anime.create!(anime_attributes)
        end

        # genres
        if params_hash["genres"].present?
          gernes_collection = []
          params_hash["genres"].split(", ").each do |genre_name|
            genre = Genre.find_by(name: genre_name)
            if not genre.present?
              genre = Genre.create!({name: genre_name})
              warnings[:new_genres] << genre_name
            end
            gernes_collection << genre
          end
          anime.genres.destroy_all
          anime.genres = gernes_collection
        else
          warnings[:animes_without_a_genre] << anime.name
        end

        # rating
        new_rating = params_hash["rating"] || 0
        old_rating = Rating.find_by({anime_id: anime.id, user_id: user.id})
        if old_rating.present?
          old_rating.update!({rating: new_rating})
        else
          Rating.create!({anime_id: anime.id, user_id: user.id, rating: new_rating})
        end

        # user
        anime.update!(user: user)

      end
    end
    
    warnings
  end

  def average_rating(new_rating = nil)
    count = self.ratings.to_a.count
    count += 1 if new_rating.present?
    if count.zero?
      nil
    else
      ratings = self.ratings.map(&:rating)
      ratings << new_rating if new_rating.present?
      sum = ratings.sum
      avr = sum.to_f/count
      avr.round(1)
    end
  end

  # Erstellt ein nach Anfangsbuchstaben sortierter Hash mit gegebenen Animes
  def self.create_alphabetical_index(animes, schluessel = :name)
    index = {}
    animes.order(schluessel).each do |anime|
      letter = anime.send(schluessel).to_s.capitalize[0,1]
      letter = '#' unless ('A'..'Z').member?(letter) # Wenns kein Buchstabe ist, muss es ins #
      index[letter] = [] unless index[letter]
      index[letter] << anime
    end
    index
  end

end
