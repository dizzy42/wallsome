class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :null => false
      t.string :encrypted_password, :limit => 128, :null => false
      t.string :salt, :limit => 128, :null => false
      t.string :remember_token, :limit => 128, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
