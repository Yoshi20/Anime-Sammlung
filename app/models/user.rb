class User < ActiveRecord::Base
  has_many :ratings


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # run rake db:migrate after a change
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # Besides :streches, you can define:
         # :pepper, :encryptor, :confirm_within, :remember_for, :timeout_in, :unlock_in, ...

  #before_action :authenticate_user!
  #.user_signed_in?
  #.current_user
  #.user_session

  #after_sign_in_path_for :...
  #after_sign_out_path_for :...

 #  after_create :login_data_notification


	# def login_data_notification
	# 	UserMailer.login_data().deliver
	# end


  def get_rating_for(anime)
    ratings.find_by(anime:anime)
  end

  def set_rating_for(anime, new_rating)
    r = Rating.find_or_create_by({anime:anime, user:self}) # get or create a rating
    r.rating = new_rating  # set new rating
    r.save
  end

end
