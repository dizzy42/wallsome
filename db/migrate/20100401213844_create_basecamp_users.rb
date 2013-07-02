class CreateBasecampUsers < ActiveRecord::Migration
  def self.up
    create_table :basecamp_users do |t|
      t.references :user, :basecamp_account
      t.string :api_token, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :basecamp_users
  end
end
