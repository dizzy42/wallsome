class BasecampAccountsController < ApplicationController
  skip_around_filter :set_resource_site_and_user
  skip_around_filter :recover_from_ssl_changes_to_basecamp_accounts
  
  def index
    if current_user.basecamp_accounts.count == 1
      redirect_to projects_url(:basecamp_account_name => current_user.basecamp_accounts.first.name)
    end
  end
end
