class User < ActiveRecord::Base
  #  attr_accessible is important for preventing a mass assignment vulnerability, 
  # a distressingly common and often serious security hole in many Rails applications.
  attr_accessible :name, :email
  
  validates :name, :presence => true
  
end
