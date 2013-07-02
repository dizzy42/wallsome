class SessionsController < ApplicationController

  skip_before_filter :authenticate
  skip_around_filter :set_resource_site_and_user
  skip_around_filter :recover_from_ssl_changes_to_basecamp_accounts
  
  before_filter :redirect_if_logged_in, :except => [:destroy]
  
  layout "logged_out"
  
  def new
  end
  
  def create
    @user = ::User.authenticate(params[:session][:email],
                                params[:session][:password])
    if @user.nil?
      flash[:error] = "Your email and/or password did not match"
      render :template => 'sessions/new', :status => :unauthorized
    elsif !@user.verified?
      flash[:error] = "Your account has not been verified.  Please check your inbox for a verification email."
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      logged_in_redirect
    end
  end
  
  def destroy
    sign_out
    redirect_to login_url
  end
  
  
  private
  
    def logged_in_redirect
      if current_user.basecamp_accounts.size == 1
        redirect_to projects_url(:basecamp_account_name => current_user.basecamp_accounts.first.name)
      else
        redirect_to basecamp_accounts_url
      end
    end
    
    def redirect_if_logged_in
      logged_in_redirect if current_user.present?
    end
  
end
