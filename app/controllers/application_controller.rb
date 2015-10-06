class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action { @section = '' }

  #define number of items per page to paginate
  def get_number_of_items_per_page
  	20
  end

end
