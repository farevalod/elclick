class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  def new
  	@user = User.new
  	@title = "Sign up"
  end

  def create
  	@user = User.new(params[:user])
	if @user.save
		sign_in @user
		flash[:success] = "Bienvenido a la plataforma ElClick!"
		redirect_to @user
	else
		@title = "Sign up"
		render 'new'
	end
  end

  def index
	@title = "Usuarios"
	@users = User.paginate(:page => params[:page])
  end

  def show
  	@user = User.find(params[:id])
	@posts = @user.posts.paginate(:page =>params[:page])
	@title = @user.name
  end

  def edit
	@title = "Editar Usuario"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Perfil actualizado."
      redirect_to @user
    else
      @title = "Editar Usuario"
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Usuario eliminado."
    redirect_to users_path
  end
  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
