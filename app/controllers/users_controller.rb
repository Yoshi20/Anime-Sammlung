class UsersController < ApplicationController

	def index
  	@users = User.all
	end

	def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
	end

	def new

	end

	def edit

	end

	def create

	end

	def update

	end

	def destroy

	end

  private
  	# def ...

  	# end

end