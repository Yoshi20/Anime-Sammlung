class User < ActiveRecord::Base
  has_many :ratings, dependent: :destroy


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
    @_all_ratings ||= ratings.to_a
    @_all_ratings.select{|r| r.anime == anime}.first
  end

end
