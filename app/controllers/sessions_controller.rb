class SessionsController < ApplicationController
  def new
  	@title = "Registrarse"
  end

  def create
	  user = User.authenticate(params[:session][:email],
							   params[:session][:password])
	  flash.now[:notice] = "user: #{!user.nil?}"
	  if user.nil?
		# Create an error message and re-render the signin form.
		flash.now[:error] = "Error(es) en email/password"
	    @title = "Ingresar"
    	render 'new'
	  else
		# Sign the user in and redirect to the user's show page.
    	sign_in user
	    redirect_back_or user
	  end
  end

  def destroy
      sign_out
      redirect_to root_path
  end
end
