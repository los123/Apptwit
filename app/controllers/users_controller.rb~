class UsersController < ApplicationController

	# standard Rails params object to retrieve the user id. When we make the appropriate 
	# request to the Users controller, params[:id] will be the user id 1, 
	# so the effect is the same as the find command
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @title = "Sign up"
  end

end
