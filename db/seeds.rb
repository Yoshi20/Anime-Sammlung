# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

genres = %w(Action Adventure Comedy Drama Ecchi Fantasy Game Gourmet Harem Hentai Historical Horror Mahō-Shōjo Mecha Music Mystery Parody Psychological Romance School Sci-Fi Sentai Super-Sentai Slice-of-Life Splatter Sport Thriller Vampire)
genres.each_with_index do |genre, index|
  id = index + 1
  Genre.find_or_create_by!(id: id, name: genre)
end

TargetAudience.find_or_create_by!(id: 1, name:'Josei')
TargetAudience.find_or_create_by!(id: 2, name:'Kodomo')
TargetAudience.find_or_create_by!(id: 3, name:'Seinen')
TargetAudience.find_or_create_by!(id: 4, name:'Shōjo')
TargetAudience.find_or_create_by!(id: 5, name:'Shōnen')
