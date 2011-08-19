class UsersController < ApplicationController
  def new
  	@user = User.new
  	@title = "Sign up"
  end

  def create
  	@user = User.new(params[:user])
	if @user.save
		flash[:success] = "Bienvenido a la plataforma ElClick!"
		redirect_to @user
	else
		@title = "Sign up"
		render 'new'
	end
  end

  def show
  	@user = User.find(params[:id])
	@title = @user.name
  end
end
