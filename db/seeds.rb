# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Anime-Ratings:
Genre.find_or_create_by(name:'Etchi')
Genre.find_or_create_by(name:'Gourmet')
Genre.find_or_create_by(name:'Harem')
Genre.find_or_create_by(name:'Josei')
Genre.find_or_create_by(name:'Kodomo')
Genre.find_or_create_by(name:'Mahō-Shōjo')
Genre.find_or_create_by(name:'Mecha')
Genre.find_or_create_by(name:'Seinen')
Genre.find_or_create_by(name:'Sentai')
Genre.find_or_create_by(name:'Super-Sentai')
Genre.find_or_create_by(name:'Shōjo')
Genre.find_or_create_by(name:'Shōnen')
Genre.find_or_create_by(name:'Sport')
Genre.find_or_create_by(name:'Horror')
Genre.find_or_create_by(name:'Psychological')
Genre.find_or_create_by(name:'Thriller')
Genre.find_or_create_by(name:'Mystery')
Genre.find_or_create_by(name:'Vampire')
Genre.find_or_create_by(name:'Historical')
Genre.find_or_create_by(name:'Adventure')

# initial Admin
User.create!(email: "admin@admin.ch", password: "1234", username: "admin", is_admin: true)
