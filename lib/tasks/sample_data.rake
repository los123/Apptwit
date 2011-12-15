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
    admin = User.create!(:name => "AdminUser",
                         :email => "admin@rails.org",
                         :password => "foobar",
                         :password_confirmation => "foobar")
                  admin.toggle!(:admin) # this line makes user an admin by placing true in admin column in DB       
                 
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
      end             
                   
     50.times do
        User.all(:limit => 6).each do |user|
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
      
    end
  end
end
