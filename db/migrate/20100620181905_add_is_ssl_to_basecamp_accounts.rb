class AddIsSslToBasecampAccounts < ActiveRecord::Migration
  def self.up
    add_column :basecamp_accounts, :is_ssl, :boolean
  end

  def self.down
    remove_column :basecamp_accounts, :is_ssl
  end
end
