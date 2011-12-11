module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  # FOR ABOVE
  # 1.
  # The assignment value on the right-hand side [user.id, user.salt]) is an array consisting of a unique identifier 
  # (i.e., the user’s id) and a secure value used to create a digital signature to prevent the kind of attacks described in Section 7.2. 
  # 2.
  # self.current_user = user
  # The purpose of this line is to create current_user, accessible in both controllers and views, which will allow constructions such 
  # as <%= current_user.name %> and redirect_to current_user 
  # 3. 
  # Our authentication method is to place a remember token as a cookie on the user’s browser (Box 9.2), and then use the token 
  # to find the user record in the database as the user moves from page to page
  
  def current_user=(user)
    @current_user = user
  end
  
   def current_user
    @current_user ||= user_from_remember_token
  end
  # ||= (“or equals”) assignment operator 
  # Its effect is to set the @current_user instance variable to the user corresponding to the remember token, but only if 
  # @current_user is undefined.  In other words, the construction @current_user ||= user_from_remember_token calls the 
  # user_from_remember_token method the first time current_user is called, but on subsequent invocations 
  # returns @current_user without calling user_from_remember_token.
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  #def redirect_back_or(default)
   # redirect_to(session[:return_to] || default)
    #clear_return_to
  #end
  
  
private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)  
      # * operator, which allows us to use a two-element array as an argument to a method expecting two variables
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
  
end

