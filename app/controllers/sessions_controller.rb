class SessionsController < ApplicationController
	
  def new
  @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_to user
    end
    end
    
    def destroy
    sign_out
    redirect_to root_path
    end
  
  
end


  ## COMMENTS FOR ABOVE - def create
  
  # 1. User.authenticate  
# We extract the submitted email address and password from the params hash, and then pass them to the User.authenticate method. 
# If the user is not authenticated (i.e., if it�s nil), we set the title and re-render the signin form.

# 2. Flash.now - Eror handling
# Recall from Section 8.4.2 that we displayed signup errors using the User model error messages. 
# Since the session isn�t an Active Record model, this strategy won�t work here, so instead we�ve put a message in the flash 
# (or, rather, in flash.now; see Box 9.1). Thanks to the flash message display in the site layout (Listing 8.16), 
# the flash[:error] message automatically gets displayed; thanks to the Blueprint CSS, it automatically gets nice styling   

# 3. FLASH.NOW
# There�s a subtle difference between flash and flash.now. 
# The flash variable is designed to be used before a redirect, and it persists on the resulting page for one request�that is, 
# it appears once, and disappears when you click on another link. (Unfortunately, this means that if we don�t redirect, 
# and instead simply render a page (as in Listing 9.8), the flash message persists for two requests: it appears on the rendered 
# page but is still waiting for a �redirect� (i.e., a second request), and thus appears again if you click a link.
# To avoid this weird behavior, when rendering rather than redirecting we use flash.now instead of flash. 
# The flash.now object is specifically designed for displaying flash messages on rendered pages. If you ever find yourself wondering why a flash message is showing up where you don�t expect it, chances are good that you need to replace flash with flash.now.


