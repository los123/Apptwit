require 'digest'

class User < ActiveRecord::Base
  # attr_accessible is important for preventing a mass assignment vulnerability, a distressingly common and often serious security hole in many Rails applications.
  # Since we’ll be accepting passwords and password confirmations as part of the signup process we need to add the password and 
  # its confirmation to the list of accessible attributes 
    attr_accessible :name, :email, :password, :password_confirmation
  
  # We use "attr_accessor :password" to create a virtual password attribute
  # I had to add :salt to attr_accessor because I was getting an error
  # undefined local variable or method `salt' for #<User:0x44f9fe8>
  attr_accessor :password, :salt
  
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
   		   :length   => { :maximum => 20 }
   		   
  validates :email, :presence => true,
   		    :format   => { :with => email_regex },
   		    :uniqueness => { :case_sensitive => false }
   		    
  # Special validation "validates :password, :confirmation => true" will automatically create a virtual attribute 
  # called password_confirmation, while confirming that it matches the password attribute at the same time.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..15 }
                       
  before_save :encrypt_password
  
  # Return true if stored user's password matches the submitted password
  # The has_password? method will test whether a user has the same password as one submitted on a sign-in form  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  
  # It handles two cases (invalid email and a successful match) with explicit return keywords, 
  # and handles the third case (password mismatch) implicitly, since in that case we reach the 
  # end of the method, which automatically returns nil.
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  	  		  
private

# All methods defined after private are used internally by the object and are not intended for public use
# In the present context, making the encrypt_password and encrypt methods private isn’t strictly necessary, but it’s a good practice 
# to make them private unless they are needed for the public interface

    def encrypt_password 
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password) 
    end
    # Here the encrypt_password callback delegates the actual encryption to an encrypt method
    # This method contains two subtleties: 
    # First***    The left-hand side of the statement explicitly assigns the encrypted_password attribute using the self keyword. 
    #             The class self refers to the object itself, which for the User model is just the user.
    #             The use of self is required in this context; if we omitted - Ruby would create a local variable called 
    #             encrypted_password, which isn’t what we want at all.
    # Second***   Inside the User class, the user object is just self, and we could write 
    #             self.encrypted_password = encrypt(self.password)
    #             But the self is optional here, so for brevity we can write simply self.encrypted_password = encrypt(password)
    

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
   		    
end
