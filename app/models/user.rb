class User < ActiveRecord::Base
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  has_many :animes
  has_many :ratings, dependent: :destroy

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  validate :validate_username

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

  # after_create :login_data_notification

	# def login_data_notification
	# 	UserMailer.login_data().deliver
	# end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def get_rating_for(anime)
    # Rating.find_by(user_id: self, anime_id: anime)
    @_all_ratings ||= ratings.to_a
    @_all_ratings.select{|r| r.anime == anime}.first
  end

end
