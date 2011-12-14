class UsersController < ApplicationController
  
############# BEFORE filters ###################################
############# BEFORE filters ###################################

before_filter :authenticate, :only => [:index,:edit, :update]
# before filter arranges for a particular method to be called before t
# he given actions.
# In this case, we define an authenticate method and invoke it using 
# before_filter :authenticate. (See authenticate method in private section)
# By default, before filters apply to every action in a controller, so here 
# we restrict the filter to act only on the :edit and :update actions by passing 
# the :only options hash.
before_filter :correct_user, :only => [:edit, :update]
# See correct_user method defines in private section

before_filter :admin_user,   :only => :destroy
# A before filter restricting the destroy action to admins. 

############# BEFORE filters END ###################################




	def index
    @title = "All users"
    @users = User.paginate(:page => params[:page]) #on Windows - restart webrick for this setting to kick in
    WillPaginate.per_page = 10 #on Windows - restart webrick for this setting to kick in
  end

# We can paginate the users in the sample application by using paginate in 
# place of all in the index action (Listing 10.28). Here 
# the :page parameter comes from params[:page], which is generated automatically 
# by will_paginate.
# User.paginate pulls the users out of the database one chunk at a time 
# (30 by default), based on the :page parameter.
# :page parameter comes from params[:page], which is generated automatically 
# by will_paginate.

	
	# standard Rails params object to retrieve the user id. When we make the appropriate 
	# request to the Users controller, params[:id] will be the user id 1, 
	# so the effect is the same as the find command
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    #  raise params[:user].inspect
    @user = User.new(params[:user])
    if @user.save
    	    sign_in @user
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
  
  def edit
    # @user = User.find(params[:id])  Line removed in chater 10. Explanation for this: 
    # "but now that the correct_user before filter defines @user we can omit it from the edit action 
    #(and from the update action as well).
    @title = "Edit user"
  end

def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
 
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

########### PRIVATE SECTION #################3

private

    def authenticate
      deny_access unless signed_in?
    end
    
# deny_access 
# Since access denial is part of authentication, we’ll put it in the 
# Sessions helper. All deny_access does is put a message in flash[:notice] 
# and then redirect to the signin page

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
###################### EL FONDO ###############
end
