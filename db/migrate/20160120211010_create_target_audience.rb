class CreateTargetAudience < ActiveRecord::Migration

  def change
    create_table :target_audience do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :animes_target_audience, id: false do |t|
      t.belongs_to :anime, index: true
      t.belongs_to :target_audience, index: true
    end

  end

end
