class BasecampUsersController < ApplicationController
  skip_around_filter :set_resource_site_and_user
  skip_around_filter :recover_from_ssl_changes_to_basecamp_accounts
  
  def index
  end
  
  def new
    @basecamp_user = current_user.basecamp_users.build
    @basecamp_user.basecamp_account = BasecampAccount.new
  end
  
  def create
    @basecamp_user = current_user.basecamp_users.build(params[:basecamp_user])
    if @basecamp_user.save
      redirect_to basecamp_users_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @basecamp_user = current_user.basecamp_users.find(params[:id])
  end
  
  def update
    @basecamp_user = current_user.basecamp_users.find(params[:id])
    @basecamp_user.attributes = params[:basecamp_user]
    if @basecamp_user.save
      redirect_to basecamp_users_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @basecamp_user = current_user.basecamp_users.find(params[:id])
    @basecamp_user.destroy
    redirect_to basecamp_users_url
  end
end
