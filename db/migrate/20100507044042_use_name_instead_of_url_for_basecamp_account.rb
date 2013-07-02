class UseNameInsteadOfUrlForBasecampAccount < ActiveRecord::Migration

  def self.up
    add_column :basecamp_accounts, :name, :string, :null => false, :default => ""
    
    BasecampAccountForUp.all.each do |ba|
      ba.update_attribute(:name, ba.name)
    end
    
    remove_column :basecamp_accounts, :url
    add_index :basecamp_accounts, :name, :unique => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
  private
  
    class BasecampAccountForUp < ActiveRecord::Base
      set_table_name "basecamp_accounts"
      
      def name
        /^https?:\/\/(.*)\..*\..*/.match(url)
        $1
      end
    end
end