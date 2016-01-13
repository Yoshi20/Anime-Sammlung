class AddOvaAndSpecialsToAnimes < ActiveRecord::Migration
  def change
    add_column :animes, :special_episodes, :integer
    add_column :animes, :ova_episodes, :integer
  end
end
