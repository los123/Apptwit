class MicropostsController < ApplicationController
  before_filter :authenticate
# Note that we haven’t restricted the actions the before filter applies to, 
# since presently it applies to them both. If we were to add, say, an index 
# action accessible even to non-signed-in users, we would need to specify the 
# protected actions explicitly
# before_filter :authenticate, :only => [:create, :destroy]

  
def create
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      render 'pages/home'
    end
  end


end