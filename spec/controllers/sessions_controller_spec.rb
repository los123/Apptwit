require 'spec_helper'

describe SessionsController do
  render_views

################ TESTS FOR 'NEW' SESSION ACTION AND VIEW #####################

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
    
##########  TEST FOR A FAILED SIGN-IN ATTEMPT ################################

 describe "POST 'create'" do
    
    describe "invalid signin" do
    
      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end
      
      it "should re-render the new page" do
      post :create, :session => @attr
      response.should render_template('new')
      end

      it "should have the right title" do
      post :create, :session => @attr
      response.should have_selector("title", :content => "Sign in")
      end

      it "should have a flash.now message" do
      post :create, :session => @attr
      flash.now[:error].should =~ /invalid/i
      end
      
    end
  end
  
#################  TEST FOR USER SIGN-IN  ####################################

describe "with valid email and password" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      # The new test uses the controller variable (which is available inside Rails tests) to check that the current_user variable 
      # is set to the signed-in user, and that the user is signed in
      # The second line may be a little confusing at this point, but you can guess based on the RSpec convention for boolean 
      # methods that controller.should be_signed_in is equivalent to controller.signed_in?.should be_true	
      
      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
  

    
################# TEST FOR DESTROYING A SESSION (USER SIGNOUT) #################

describe "DELETE 'destroy'" do
    
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
  
  # The only novel element here is the delete method, which issues an HTTP DELETE request (in analogy 
  # with the get and post methods seen in previous tests), as required by the REST conventions
  
  
  
################# EL FONDO ###################################################
  
  
  end
end

