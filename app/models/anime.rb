class Anime < ActiveRecord::Base
  has_and_belongs_to_many :genres
  belongs_to :user
  has_many :ratings, dependent: :destroy

  validates :name, :rating, presence: true
  validates :name, uniqueness:true, length:{maximum:50}
  validates :episodes, length:{minimum:1}
  validates :episodes, numericality: {greater_than: 0}
  validates :rating, inclusion: {in: 0..6}

  # define max rating
  MAX_RATING = 6

  # chia-anime image-url
  def image_url
    url = 'http://cdn.chia-anime.tv/content/cache2/'
    url += self.name.gsub(' ', '-')
    url += '.jpg'
  end

  # to add the name into the url
  def to_param
    "#{id} #{name}".parameterize
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      :all
    end
  end

  # def self.import(file)
  #   warnings = {unbekannte_genres: []}
  #   CSV.foreach(file.path, headers:true) do |row|
  #     allowed_columns = %w(name genres episodes finished description comment rating)
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

  def self.import(file, user)
    warnings = {updated_animes: [], new_genres: []}
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open file.path
    sheet = book.worksheet 0 # use only the first worksheet
    sheet.each do |row|

      permitted_columns = %w(name genres episodes finished description comment rating)
      row = row.premit(permitted_columns)

      raise row.inspect

      anime_attributes = permitted_columns.except(:genres, :rating)
      #anime_attributes = row.to_hash.keep_if{|key, _value| anime_attributes.include?(key)}

      # anime
      anime = Anime.find_by(name: anime_attributes["name"])
      if anime.present?
        anime.update(anime_attributes)
        warnings[:updated_animes] << "#{anime.name} (anime attributes)"
      else
        anime = Anime.create!(anime_attributes)
      end

      # genres
      permitted_columns[:genres].split(", ").each do |genre_name|
        genre = Genre.find_by(name: genre_name)
        if not genre.present?
          genre = Genre.create!({name: genre_name})
          warnings[:new_genres] << genre_name
        end
        raise anime.genres.inspect
        anime.genres.merge(genre)
      end

      # rating
      new_raiting = permitted_columns[:rating] || 0
      old_raiting = Rating.find_by({anime_id: anime.id, user_id: user.id})
      if old_rating.present?
        if current_user != user
          #...
        end
        rating.update({user_id: user.id, rating: new_rating})
        warnings[:updated_animes] << "#{anime.name} (rating)"
      else
        Rating.create!({anime_id: anime.id, user_id: user.id, rating: new_rating})
      end

      # user
      anime.user = user
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
      avr.round(2)
    end
  end

end
