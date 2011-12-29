class Relationship < ActiveRecord::Base
  
  attr_accessible :followed_id
  # As with any new model, before moving on, we should define the model’s accessible 
  # attributes. In the case of the Relationship model, the followed_id should be 
  # accessible, since users will create relationships through the web, but the 
  # follower_id attribute should not be accessible; otherwise, malicious users could 
  # force other users to follow them. 
  
  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"
  #Relationship model has a belongs_to relationship with users; in this case, a 
  # relationship object belongs to both a follower and a followed user

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
  
end
