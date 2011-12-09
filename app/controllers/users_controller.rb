class UsersController < ApplicationController

	# standard Rails params object to retrieve the user id. When we make the appropriate 
	# request to the Users controller, params[:id] will be the user id 1, 
	# so the effect is the same as the find command
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
    	    flash[:success] = "Welcome to the Blue Bird Microblog!"
    redirect_to @user
    # Handle a successful save.
    # @user = User.new(params[:user]) IS EQUIVALENT TO:
    # @user = User.new(:name => "Foo Bar", :email => "foo@invalid", :password => "dude", :password_confirmation => "dude")
    else
      @title = "Sign up"
      render 'new'
    end
  end

end
