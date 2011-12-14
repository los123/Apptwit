# By using the symbol ':user', we get Factory Girl to simulate the User model.

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end


# DONE FOR PAGINATION TESTING
# Factory Girl provides sequences for creating multiple ussers

Factory.sequence :name do |n|
  "Person #{n}"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
# This arranges to return email addresses like person-1@example.com, 
# person-2@example.com