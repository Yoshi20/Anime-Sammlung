class RemoveGenresColumnFromAnimes < ActiveRecord::Migration
  def up
    remove_column :animes, :genre
  end

  def down
    add_column :animes, :genre, :string # possible options to add are: default:false, limit:30, null:false, frist:true, after:email, unique:true
  end
end
