class AddUserToAnimes < ActiveRecord::Migration
  def change
    add_reference :animes, :user, index: true, foreign_key: true
  end
end
