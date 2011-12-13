require 'spec_helper'

describe UsersController do
  render_views

############### TESTS FOR SHOW PAGE ###############
############### TESTS FOR SHOW PAGE ###############

  describe "GET 'show'" do
    
before(:each) do
  @user = Factory(:user)
end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
      end
      
      # Investigate later, has errors
      # have_selector method verifies the presence of a title and h1 tags containing the user�s name.
      # it "should have the right title" do
      # get :show, :id => @user
      # response.should have_selector("title", :content => @user.name)
      # end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    # h1>img makes sure that the img tag is inside the h1 tag.
    # In addition, we see that have_selector can take a :class option to test the CSS class of the element in question.
    # It�s not necessarily always a good idea to make HTML tests this specific, since we don�t always want to constrain 
    # the HTML layout this tightly. Feel free to experiment and find the right level of detail for your projects and tastes. 
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
    end

    
############### TEST FOR NEW PAGE ###############
############### TEST FOR NEW PAGE ###############
    
before(:each) do
  @base_title = "Ruby on Rails Tutorial Sample App"
end
  
describe "GET 'new'" do
  	  
    it "returns http success" do
    get :new
    response.should be_success
  end
    
   
    it "Should have the right title" do
    get :new
    response.should have_selector("title", :content => "Sign up")
    end
  end
 
############### TEST FOR SIGNUP PAGE ###############
############### TEST FOR SIGNUP PAGE ###############


describe "POST 'create'" do

    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
          end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      # The purpose of the test ABOVE is to verify that a failed create action doesn�t create a user in the database. 
      # First, we use the RSpec change method to return the change in the number of users in the database: change(User, :count)
      # This defers to the Active Record count method, which simply returns how many records of that type are in the database. 
      # The second new idea is to wrap the post :create step in a package using a Ruby construct called a lambda, which 
      # allows us to check that it doesn�t change the User count
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end
          
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      #The final two tests are relatively straightforward: we make sure that the title is correct, 
      # and then we check that a failed signup attempt just re-renders the new user page (using the render_template RSpec method)
      
    end
  end

#######   TESTING THAT NEWLY SIGNED-UP USERS ARE ALSO SIGNED IN ##############
#######   TESTING THAT NEWLY SIGNED-UP USERS ARE ALSO SIGNED IN ##############

     it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
     end
     
     
############## TEST FOR THE USER EDIT ACTION ###############
############## TEST FOR THE USER EDIT ACTION ###############


    describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    #Here we’ve made sure to use test_sign_in(@user) to sign in as the user in anticipation of protecting 
    # the edit page from unauthorized access (Section 10.2). Otherwise, these tests would break as soon 
    # as we implemented our authentication code.
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
  end

############### TEST FOR USER UPDATE ACTION ######################
############### TEST FOR USER UPDATE ACTION ######################

describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end
    end

describe "success" do
      
      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end
# The only novelty here is the reload method.
# This code reloads the @user variable from the (test) database using 
# @user.reload, and then verifies that the user’s new name and email 
# match the attributes in the @attr hash.
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
    
#### SECURITY RESTRICTIONS FOR EDIT AND UPDATES PAGES ##########
#### REQUIRING THE RIGHT USER ##########

# 1. tests verify that non-signed-in users attempting to access either 
# action are simply redirected to the signin page

describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
    
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
  end
  
# Test for this by first signing in as an incorrect user and then hitting 
# the edit and update actions. Since users should never even try to edit 
# another user’s profile, we redirect not to the signin page but to the root url.
describe "for signed-in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end

############### TESTS FOR USER INDEX PAGE ######################
##############  TESTS FOR USER INDEX PAGE ######################

# Although we’ll keep individual user show pages visible to all site visitors, 
# the user index will be restricted to signed-in users so that there’s a limit 
# to how much unregistered users can see by default. 

describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "another@example.com")
        third  = Factory(:user, :name => "Ben", :email => "another@example.net")
        
        @users = [@user, second, third]
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
    end
  end

  
############### EL FONDO ######################

end


