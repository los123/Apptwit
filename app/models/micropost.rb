class Micropost < ActiveRecord::Base
  
attr_accessible :content
# Failing to define accessible attributes means that anyone could change any aspect 
# of a micropost object simply by using a command-line client to issue malicious 
# requests. For example, a malicious user could change the user_id attributes on 
# microposts, thereby associating microposts with the wrong users.
# In the case of the Micropost model, there is only one attribute that needs to 
# be editable through the web, namely, the content attribute
  
  
belongs_to :user

validates :content, :presence => true, :length => { :maximum => 140 }
validates :user_id, :presence => true


default_scope :order => 'microposts.created_at DESC'
# DESC is SQL for “descending”
# To get the ordering test to pass, we use a Rails facility called default_scope with an :order parameter

end


# The attr_accessible declaration in Listing 11.2 is necessary for site security, 
# but it introduces a problem in the default Micropost model spec 
# require 'spec_helper'

# describe Micropost do

#  before(:each) do
#    @attr = {
#      :content => "value for content",
#      :user_id => 1
#    }
#  end

# The problem is that the before(:each) block in Listing 11.3 assigns the user id 
# through mass assignment, which is exactly what attr_accessible is designed to 
# prevent; in particular, as noted above, the :user_id => 1 part of the initialization 
# hash is simply ignored. The solution is to avoid using Micropost.new directly; 
# instead, we will create the new micropost through its association with the User 
# model, which sets the user id automatically. 