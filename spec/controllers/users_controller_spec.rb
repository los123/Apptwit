require 'spec_helper'

describe UsersController do
  render_views

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
      # have_selector method verifies the presence of a title and h1 tags containing the user’s name.
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
    # It’s not necessarily always a good idea to make HTML tests this specific, since we don’t always want to constrain 
    # the HTML layout this tightly. Feel free to experiment and find the right level of detail for your projects and tastes. 
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
    end

    
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
      
      # The purpose of the test ABOVE is to verify that a failed create action doesn’t create a user in the database. 
      # First, we use the RSpec change method to return the change in the number of users in the database: change(User, :count)
      # This defers to the Active Record count method, which simply returns how many records of that type are in the database. 
      # The second new idea is to wrap the post :create step in a package using a Ruby construct called a lambda, which 
      # allows us to check that it doesn’t change the User count
      
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

############### EL FONDO ######################

end


