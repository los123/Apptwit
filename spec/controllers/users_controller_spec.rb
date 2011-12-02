require 'spec_helper'

 before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

describe UsersController do

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


