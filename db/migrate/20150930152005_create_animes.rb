class CreateAnimes < ActiveRecord::Migration
  def change
    create_table :animes do |t|
      t.string :name
      t.string :genre
      t.integer :number_of_episodes
      t.boolean :finished
      t.text :description
      t.float :rating

      t.timestamps null: false
    end
  end
end
