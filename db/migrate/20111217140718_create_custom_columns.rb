class CreateCustomColumns < ActiveRecord::Migration
  def self.up
    create_table :custom_columns do |t|
      t.string     :name,       :null => false
      t.integer    :position,   :null => false
      t.integer    :project_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_columns
  end
end
