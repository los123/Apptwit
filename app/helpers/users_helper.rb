module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => h(user.name),
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end

# option = { :size => 50 } --- This sets the default Gravatar size to 50x50
# Gravatars are square, so a single parameter determines their size uniquely.

# 1.
# The first argument in the call to gravatar_image_tag passes in the lower-case version of the user’s email address 
# (using the downcase method)
# 2.
# Then the first option to gravatar_image_tag uses the h method to assign an HTML escaped version of the user’s name 
# to the img tag’s alt attribute (which gets displayed in devices that can’t render images)
# 3.
# The second option sets the CSS class of the resulting Gravatar. 
# 4.
# The third option passes the options hash using the :gravatar key, which (according to the gravatar_image_tag gem documentation) 
# is how to set the options for gravatar_image_tag. 
