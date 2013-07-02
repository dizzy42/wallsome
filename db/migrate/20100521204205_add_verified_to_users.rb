class AddVerifiedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :verified, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :verified
  end
end
