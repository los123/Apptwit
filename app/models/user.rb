class User < ActiveRecord::Base
  #  attr_accessible is important for preventing a mass assignment vulnerability, 
  # a distressingly common and often serious security hole in many Rails applications.
  attr_accessible :name, :email
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
   		   :length   => { :maximum => 20 }
  validates :email, :presence => true,
   		    :format   => { :with => email_regex },
   		    :uniqueness => { :case_sensitive => false }
end
