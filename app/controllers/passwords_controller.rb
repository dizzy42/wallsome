class PasswordsController < ApplicationController
  skip_before_filter :authenticate, :only => [:new, :create, :edit, :update]
  skip_around_filter :set_resource_site_and_user
  skip_around_filter :recover_from_ssl_changes_to_basecamp_accounts
  
  before_filter :redirect_to_root, :only => [:new, :create], :if => :signed_in?
  before_filter :forbid_non_existent_user, :only => [:edit, :update]
  
  layout "logged_out"
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:email])
    
    if user 
      user.forgot_password!
      PasswordMailer.forgot(user).deliver
      flash[:notice] = "You should receive an email shortly explaining how to restore your password."
      redirect_to login_url
    else
      flash[:error] = "Something went wrong. Please verify you entered the correct email address."
      redirect_to new_password_url
    end
  end
  
  def edit
    @user = ::User.find_by_id_and_verification_token(
                   params[:user_id], params[:token])
    render :edit, :layout => 'logged_in'
  end
  
  def update
    @user = ::User.find_by_id_and_verification_token(
                   params[:user_id], params[:token])

    if @user.update_password(params[:user][:password],
                             params[:user][:password_confirmation])
      @user.confirm_email!
      sign_in(@user)
      redirect_to basecamp_accounts_url
    else
      render :edit
    end
  end
  
  private
  
    def forbid_non_existent_user
      unless ::User.find_by_id_and_verification_token(
                    params[:user_id], params[:token])
        flash[:error] = "Something went wrong.  You may need to click the forgot password link again, and follow the link in the new email."
        redirect_to login_url
      end
    end
end
