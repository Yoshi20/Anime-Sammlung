# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Genre.find_or_create_by!(id: 1, name:'Etchi')
Genre.find_or_create_by!(id: 2, name:'Gourmet')
Genre.find_or_create_by!(id: 3, name:'Harem')
Genre.find_or_create_by!(id: 6, name:'Mahō-Shōjo')
Genre.find_or_create_by!(id: 7, name:'Mecha')
Genre.find_or_create_by!(id: 9, name:'Sentai')
Genre.find_or_create_by!(id: 10, name:'Super-Sentai')
Genre.find_or_create_by!(id: 13, name:'Sport')
Genre.find_or_create_by!(id: 14, name:'Horror')
Genre.find_or_create_by!(id: 15, name:'Psychological')
Genre.find_or_create_by!(id: 16, name:'Thriller')
Genre.find_or_create_by!(id: 17, name:'Mystery')
Genre.find_or_create_by!(id: 18, name:'Vampire')
Genre.find_or_create_by!(id: 19, name:'Historical')
Genre.find_or_create_by!(id: 20, name:'Adventure')
Genre.find_or_create_by!(id: 21, name:'MMORPG')
# Genre.find_or_create_by!(id: 4, name:'Josei')
# Genre.find_or_create_by!(id: 5, name:'Kodomo')
# Genre.find_or_create_by!(id: 8, name:'Seinen')
# Genre.find_or_create_by!(id: 11, name:'Shōjo')
# Genre.find_or_create_by!(id: 12, name:'Shōnen')

TargetAudience.find_or_create_by!(id: 1, name:'Josei')
TargetAudience.find_or_create_by!(id: 2, name:'Kodomo')
TargetAudience.find_or_create_by!(id: 3, name:'Seinen')
TargetAudience.find_or_create_by!(id: 4, name:'Shōjo')
TargetAudience.find_or_create_by!(id: 5, name:'Shōnen')
