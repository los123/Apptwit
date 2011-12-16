class MicropostsController < ApplicationController

# before_filter :authenticate (this was before)
# Note that we haven’t restricted the actions the before filter applies to, 
# since presently it applies to them both. If we were to add, say, an index 
# action accessible even to non-signed-in users, we would need to specify the 
# protected actions explicitly
# before_filter :authenticate, :only => [:create, :destroy]

before_filter :authenticate, :only => [:create, :destroy]
before_filter :authorized_user, :only => :destroy

  
def create
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      # There is one subtlety, though: on failed micropost submission, the 
      # Home page expects an @feed_items instance variable, so failed submissions 
      # currently break (as you should be able to verify by running your test 
      # suite). The easiest solution is to suppress the feed entirely by 
      # assigning it an empty array. This is why the line above was added.
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

################# PRIVATE SESSION ###########################

private
  
    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      # we use find_by_id instead of find because the latter raises an exception 
      # when the micropost doesn’t exist instead of returning nil. 
      redirect_to root_path if @micropost.nil?
    end
    #   

end