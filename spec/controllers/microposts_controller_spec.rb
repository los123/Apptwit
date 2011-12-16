require 'spec_helper'

##### ACCESS CONTROL TESTS FOR MICROPOSTS CONTROLLER #####

describe MicropostsController do
  render_views
  
  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  #### TESTS FOR MICROPOSTS CONTROLLER CREATE ACTION #####
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
  
    describe "failure" do
      
      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the home page" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
      end
    end
  
    describe "success" do
      
      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end
      
      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end
      
      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end
      
      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end
  end
  
  #### TESTS FOR MICROPOSTS CONTROLLER DESTROY ACTION #####
  
  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do 
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
  
  # The application code is also analogous to the user case in Listing 10.41; 
  # the main difference is that, rather than using an admin_user before filter, 
  # in the case of microposts we have an authorized_user before filter to check 
  # that the current user actually has a micropost with the given id.
  
  
#############
  
end
