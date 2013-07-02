class CreateBasecampAccounts < ActiveRecord::Migration
  def self.up
    create_table :basecamp_accounts do |t|
      t.string :url, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :basecamp_accounts
  end
end
