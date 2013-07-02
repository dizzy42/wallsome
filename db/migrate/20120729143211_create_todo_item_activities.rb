class CreateTodoItemActivities < ActiveRecord::Migration
  def self.up
    create_table :todo_item_activities do |t|
      t.references :user
      t.references :basecamp_account

      t.timestamps
    end
  end

  def self.down
    drop_table :todo_item_activities
  end
end
