namespace :db do
# rake tasks are defined using namespaces (in this case, :db)
# With this :db namespace we can invoke the Rake task as follows:
# bundle exec rake db:populate or rake db:populate

# This defines a task db:populate that resets the development database using 
# db:reset (using slightly weird syntax you shouldn’t worry about too much), 
# creates an example user with name and email address replicating our previous 
# one, and then makes 99 more. 

  desc "Fill database with sample data"
  task :populate => :environment do
  # ensures that the Rake task has access to the local Rails environment, 
  # including the User model (and hence User.create!)
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "Example User",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  User.all(:limit => 6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(:content => content)
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

# We somewhat arbitrarily arrange for the first user to follow the next 50 users, 
# and then have users with ids 4 through 41 follow that user back. 
# The resulting relationships will be sufficient for developing the application 
# interface.
