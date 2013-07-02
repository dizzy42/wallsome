class TodoItemActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :basecamp_account
end
