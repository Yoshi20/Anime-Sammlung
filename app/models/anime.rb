class Anime < ActiveRecord::Base
  has_and_belongs_to_many :genres
  has_many :ratings, dependent: :destroy

  validates :name, :rating, presence: true
  validates :name, uniqueness:true, length:{maximum:50}
  validates :episodes, length:{minimum:1}
  validates :episodes, numericality: {greater_than: 0}
  validates :rating, inclusion: {in: 0..6}

  after_save :anime_changed_notification


  # define max rating
  MAX_RATING = 6


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


  def self.import(file)
    #raise Anime.first.inspect
    warnings = {unbekannte_genres: []}
    CSV.foreach(file.path, headers:true) do |row|
      #raise row.to_hash.inspect
      #raise Anime.first.attributes.keys.inspect
      attributes = row.to_hash.keep_if{|key, _| %w(name genres episodes finished description rating).include?(key)}
      attributes["genres"] = attributes["genres"].split(" / ").map do |name|
        if g = Genre.find_by(name: name)
         g 
        else
          warnings[:unbekannte_genres] << name
          nil
        end
      end.compact
      #raise attributes["genres"].inspect
      anime = Anime.find_by(name: attributes["name"])
      if anime.present?
        anime.update_attributes attributes
      else
        Anime.create! attributes
      end
    end
    warnings
  end


  def anime_changed_notification
    #UserMailer.anime_changed(self).deliver if changed?
  end


  # def get_rating_for(user)
  #   ratings.find_by(user:user)
  # end

  def average_rating
    count = self.ratings.to_a.count
    if count.zero?
      nil
    else
      sum = self.ratings.map(&:rating).sum
      avr = sum / count
      avr.to_f.round(2)
    end
  end


end
