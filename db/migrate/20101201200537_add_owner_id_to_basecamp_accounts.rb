class AddOwnerIdToBasecampAccounts < ActiveRecord::Migration
  def self.up
    add_column :basecamp_accounts, :owner_id, :integer
  end

  def self.down
    remove_column :basecamp_accounts, :owner_id
  end
end
