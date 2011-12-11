require 'spec_helper'

describe "LayoutLinks" do
######### TEST FOR PRESENSE OF HOME PAGE ##################

  it "should have a Home page at '/'" do
    get '/'
  response.should have_selector('title', :content => "Home")
  end
  
######### TEST FOR PRESENSE OF CONTACT PAGE ##################
  
   it "Should have a Contact page at 'contact'" do
     get 'pages/contact'
   response.should have_selector('title', :content => "Contact")
  end

######### TEST FOR PRESENSE OF ABOUT PAGE ##################

  it "should have an About page at '/about'" do
    get 'pages/about'
    response.should have_selector('title', :content => "About")
  end

######### TEST FOR PRESENSE OF HELP PAGE ##################

  it "should have a Help page at '/help'" do
    get '/pages/help'
    response.should have_selector('title', :content => "Help")
  end

end

######## TESTS FOR SIGN-IN/SIGN-OUT LINKS ON THE SITE'S LAYOUT ########

describe "when not signed in" do
    
    it "should have a signin link" do
    visit root_path
    response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
end
  
describe "when signed in" do

	# BELOW
	# Here the before(:each) block signs in by visiting the signin page and submitting a valid email/password pair	
	# We do this instead of using the test_sign_in function from Listing 9.19 because test_sign_in doesn�t work 
	# inside integration tests for some reason. (See Section 9.6 for an exercise to make an integration_sign_in 
	# function for use in integration tests.)
    
          before(:each) do
            @user = Factory(:user)
            visit signin_path
            fill_in :email,    :with => @user.email
            fill_in :password, :with => @user.password
            click_button
          end
          
    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end
    
    it "should have a profile link" do
    visit root_path
    response.should have_selector("a", :href => user_path(@user),
                                       :content => "Profile")
    end
end

######### EL FONDO ##################


