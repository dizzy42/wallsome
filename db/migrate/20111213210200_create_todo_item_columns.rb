class CreateTodoItemColumns < ActiveRecord::Migration
  def self.up
    create_table :todo_item_columns do |t|
      t.integer :todo_item_id, :null => false
      t.integer :custom_column_id, :null => false
    end
  end

  def self.down
    drop_table :todo_item_columns
  end
end
