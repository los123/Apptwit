require 'spec_helper'

describe PagesController do
	render_views 
	
	    # FOR render_views
	# 1. By default RSpec just tests actions inside a controller test, if we want it also
	# to render the views, we have to tell it explicitly by using render_views
	# This ensures that if the test passes, the page is really there.
	# 2. (!!!) render_views line is necessary for the title tests to work.
	 
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
# TEST FOR home PAGE
	
  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
    
         it "Should have the right title" do
          get 'home'
            response.should have_selector("title",
                        :content => "#{@base_title} | Home")
        end
    end
  
      # FOR ABOVE
  # ---   The first line indicates that we are describing a GET operation for the home action. 
  # This is just a description, and it can be anything you want. In this case, "GET ’home’" indicates 
  # that the test corresponds to an HTTP GET request.
  # --- Then the spec says that when you visit the home page, it should be successful. 
  # As with the first line, what goes inside the quote marks is irrelevant to RSpec,
  # and is intended to be descriptive to human readers.
  # --- The third line, get ’home’, is the first line that really does something.
  # Inside of RSpec, this line actually submits a GET request
  # in other words, it acts like a browser and hits a page, in this case /pages/home
  # --- Finally, the fourth line says that the response of our application should indicate success,
  # i.e., it should return a status code of 200. 
  # When we write response.should be_success in an RSpec test, RSpec verifies 
  # that our application’s response to the request is status code 200.

# TEST FOR 'contact' PAGE

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
    
        it "Should have the right title" do
          get 'contact'
            response.should have_selector("title",
            	    :content => "#{@base_title} | Contact")
            end                 
    
  end
  
# TEST FOR 'about' PAGE

  describe "GET 'about'" do
    it "should be successfull" do
      get 'about'
        response.should be_success
      end
    end
  	  	  
        it "Should have the right title" do
          get 'about'
            response.should have_selector("title",
            	    :content => "#{@base_title} | About")
        end
        
  	  	  
        # TEST FOR 'help' PAGE

    describe "GET 'help'" do
      it "returns http success" do
      	      get 'help'
      response.should be_success
    end
    
         it "Should have the right title" do
         	 get 'help'
            response.should have_selector("title",
            	    :content => "#{@base_title} | Help")
        end
    end
  
    
end
