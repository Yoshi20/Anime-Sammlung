class CreateAnimesGenres < ActiveRecord::Migration
  def change
    create_table :animes_genres, id:false do |t|
    	t.integer :anime_id
    	t.integer :genre_id
    end
    add_index :animes_genres, :anime_id
    add_index :animes_genres, :genre_id
    
  end
end
