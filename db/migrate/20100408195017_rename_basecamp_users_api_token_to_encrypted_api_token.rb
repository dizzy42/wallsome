class RenameBasecampUsersApiTokenToEncryptedApiToken < ActiveRecord::Migration
  def self.up
    rename_column :basecamp_users, :api_token, :encrypted_api_token
  end

  def self.down
    rename_column :basecamp_users, :encrypted_api_token, :api_token
  end
end