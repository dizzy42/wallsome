class RemoveIsSslFromBasecampAccounts < ActiveRecord::Migration
  def self.up
    remove_column :basecamp_accounts, :is_ssl
  end

  def self.down
    add_column :basecamp_accounts, :is_ssl, :boolean
  end
end
