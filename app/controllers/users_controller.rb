class UsersController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:new, :create]
  skip_around_filter :set_resource_site_and_user
  skip_around_filter :recover_from_ssl_changes_to_basecamp_accounts
  
  before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?
  
  layout "logged_out"
  
  def new
    @user = User.new
    @user.basecamp_users.build
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      AccountMailer.verification(@user).deliver
      redirect_to getting_started_url
    else
      render :action => 'new'
    end
  end
  
  def show
    render "show", :layout => "logged_in"
  end
  
  def edit
    current_user.forgot_password!
    redirect_to edit_password_url(:user_id => current_user.id, 
                                  :token => current_user.verification_token)
  end
  
  def destroy
    current_user.delete
    redirect_to root_path
  end
end
