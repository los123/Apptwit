class AddEmailUniquenessIndex < ActiveRecord::Migration
	
	#This uses a Rails method called add_index to add an index on the email 
	# column of the users table. The index by itself doesn’t enforce 
	# uniqueness, but the option :unique => true does.
  def self.up
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :email
  end
end