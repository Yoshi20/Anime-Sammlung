class RenameNumberOfEpisodesToEpisodes < ActiveRecord::Migration
  def change
  	rename_column :animes, :number_of_episodes, :episodes
  end
end
