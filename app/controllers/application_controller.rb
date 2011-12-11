class ApplicationController < ActionController::Base
  protect_from_forgery
# All we need to do to use the Sessions helper functions in controllers is to include the module into the Application controller 
# By default, all the helpers are available in the views but not in the controllers. 
  include SessionsHelper
end
