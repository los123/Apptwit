class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
      #  t.timestamps line, which (as mentioned in Section 6.1.1) adds the magic 
      # created_at and updated_at columns. 
    end
    add_index :microposts, [:user_id, :created_at]
    # line was added manually, see explanation in the end of the file why index is needed.
    # By including both the user_id and created_at columns as an array, we arrange 
    # for Rails to create a multiple key index, which means that Active Record can 
    # use both keys at the same time. 
  end
end

# When creating a column in a database, it is important to consider if we will need 
# to find records by that column. Consider, for example, the email attribute created 
# by the migration in Listing 6.2. When we allow users to sign in to the sample app 
# starting in Chapter 8, we will need to find the user record corresponding to the 
# submitted email address; unfortunately, based on the naïve data model, the only way 
# to find a user by email address is to look through each user row in the database and 
# compare its email attribute to the given email. This is known in the database 
# business as a full-table scan, and for a real site with thousands of users it is a 
# Bad Thing.

# Putting an index on the email column fixes the problem. 
# To understand a database index, it’s helpful to consider the analogy of a book index.
#  In a book, to find all the occurrences of a given string, say “foobar”, you would 
# have to scan each page for “foobar”. With a book index, on the other hand, you can 
# just look up “foobar” in the index to see all the pages containing “foobar”. 
# A database index works essentially the same way.

