class RenameDescriptionToComment < ActiveRecord::Migration
  def change
    rename_column :animes, :description, :comment
    add_column :animes, :description, :text
  end
end
