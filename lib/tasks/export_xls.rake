require 'spreadsheet'

namespace :export do

  desc 'Exportiert alle Animes'
  task animes: :environment do
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.name = "Animes"
    format_titelzeile = Spreadsheet::Format.new(weight: :bold)
    anime_attributes = [
      :name,
      :target_audience,
      :genres,
      :episodes,
      :finished,
      :comment,
      :description,
      :rating,
    ]
    # table header
    sheet.row(0).push *anime_attributes.map{ |field| field.to_s.humanize }
    sheet.row(0).default_format = format_titelzeile
    # content
    Anime.all.order(:name).each_with_index do |anime, anime_index|
      anime_attributes.each_with_index do |field, field_index|
        if field == :genres
          sheet[anime_index + 1, field_index] = anime.genres.map(&:name).join(', ')
        elsif field == :target_audience
          sheet[anime_index + 1, field_index] = anime.target_audience.map(&:name).join(', ')
        elsif field == :rating
          # get my rating not the average rating
          sheet[anime_index + 1, field_index] = Rating.find_by(anime_id: anime, user_id: 1).try(:rating)
        else
          sheet[anime_index + 1, field_index] = anime.__send__(field)
        end
      end
    end

    filename = Rails.root + 'tmp' + 'animes.xls'
    begin
      File.delete(filename)
    rescue
      # noop
    end
    book.write filename
    # `open #{filename}`
  end

end
