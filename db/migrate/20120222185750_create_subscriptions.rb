class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :basecamp_account_id,   :null => false
      t.integer :user_id,               :null => false
      t.text    :hashed_referrer,       :null => false, :unique => true
      t.string  :state,                 :null => false, :default => "inactive"
      t.text    :fast_spring_reference

      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
