require 'spec_helper'

describe UsersController do
  render_views

############### TEST FOR SHOW PAGE ###############

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
      
      # have_selector method verifies the presence of a title and h1 tags containing the user’s name.
      it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

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
    get 'new'
    response.should be_success
  end
    
  it "Should have the right title" do
    get 'new'
    response.should have_selector("title", :content => "Sign up")
  end
  end
 
  
end


