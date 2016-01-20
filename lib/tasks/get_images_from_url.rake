require 'uri'
require 'open-uri'

namespace :get_images do

  desc 'Holt Bilder zu allen Animes von einer URL'
  task from_url: :environment do
    IMG_PATH = 'app/assets/images/animes/'
    IMG_TYPE = '.jpg'
    BASE_URL = 'http://cdn.chia-anime.tv/content/cache2/'
    animes = Anime.all
    animes.each do |anime|
      anime_name = anime.name.gsub(' ', '-').gsub('/', '').gsub('.', '').gsub(':', '-').gsub('%', '')
      puts anime.name + '->' + anime_name
      anime_image_path = IMG_PATH + anime_name + IMG_TYPE
      # create only if file does not exist yet
      unless File.file?(anime_image_path)
        File::open(anime_image_path, 'wb') do |file|
          bild = nil
          open(BASE_URL + URI.escape(anime_name) + IMG_TYPE) do |f|
            puts f.base_uri
            puts f.content_type
            puts ''
            bild = f.read
          end
          file << bild
        end
      end
    end
  end

end
