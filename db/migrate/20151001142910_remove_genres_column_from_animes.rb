class RemoveGenresColumnFromAnimes < ActiveRecord::Migration
  def up
    remove_column :animes, :genre
  end

  def down
  	add_column :animes, :genre, :string
  end
end
