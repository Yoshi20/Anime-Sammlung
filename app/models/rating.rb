class Rating < ActiveRecord::Base
  belongs_to :anime
  belongs_to :user

  # allow only one rating per anime per user
  validates_uniqueness_of :anime_id, scope: :user_id

end
