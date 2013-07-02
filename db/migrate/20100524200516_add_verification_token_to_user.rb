class AddVerificationTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :verification_token, :string, :limit => 128
  end

  def self.down
    remove_column :users, :verification_token
  end
end
