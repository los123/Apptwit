require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    
    	    
################ TEST THAT SIGNUP FAILURE DOESN'T PRODUCE USER CEREATION IN DB ###########
    
    describe "failure" do      

        it "should not make a new user" do
      	      # we need to wrap the test steps in a single package, and then check that it doesn�t change the User count. 
      	      # this can be accomplished with a lambda. 
      	      # lambda block can wrap multiple lines
      	      lambda do
        visit signup_path
        fill_in "Name",         :with => ""
        fill_in "Email",        :with => ""
        fill_in "Password",     :with => ""
        fill_in "Confirmation", :with => ""
        click_button
        response.should render_template('users/new')
        response.should have_selector("div#error_explanation")
              end.should_not change(User, :count)
      end
    end
    
    # Here the first arguments to fill_in are the label values, i.e., exactly the text the user sees in the browser; 
    # there�s no need to know anything about the underlying HTML structure generated by the Rails form_for helper.
    
################ TEST FOR SIGNUP SUCCESS ##################

    describe "success" do

         it "should make a new user" do
                 lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
                 end.should change(User, :count).by(1)
      end
    end
    
# By the way, although it�s not obvious from the RSpec documentation, you can use the CSS id 
# of the text box instead of the label, so fill_in :user_name also works.11 
# (This is especially nice for forms that don�t use labels.)
    

    
###########  INTEGRATION TEST FOR SIGNING IN AND OUT  #################   

describe "sign in/out" do
  
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
  
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email,    :with => user.email
        fill_in :password, :with => user.password
        click_button
            #click_link "Sign out", which not only simulates a browser clicking 
            # the signout link, but also raises an error if no such link 
            # exists—thereby testing the URL, the named route, the link text, 
            # and the changing of the layout links, all in one line. 
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end


########################################################### 


    
  end
end

