class VerificationsController < ApplicationController

  before_filter :redirect_signed_in_verified_user,  :only => [:new, :create]
  before_filter :redirect_signed_out_verified_user, :only => [:new, :create]
  before_filter :forbid_missing_token,               :only => [:new, :create]
  before_filter :forbid_non_existent_user,           :only => [:new, :create]

  skip_before_filter :authenticate, :only => [:new, :create, :edit, :update]
  skip_around_filter :set_resource_site_and_user
  skip_around_filter :recover_from_ssl_changes_to_basecamp_accounts
  
  before_filter :redirect_to_signed_in_root, :only => [:new, :create], :if => :signed_in?


  def new
    create
  end

  def create
    @user = ::User.find_by_id_and_verification_token(
                   params[:user_id], params[:token])
    @user.confirm_email!

    sign_in(@user)
    flash[:notice] = "Your account has been verified."
    redirect_to basecamp_accounts_url
  end
  
  private
  
    def redirect_signed_in_verified_user
      user = ::User.find_by_id(params[:user_id])
      if user && user.verified? && current_user == user
        redirect_to basecamp_accounts_url
      end
    end

    def redirect_signed_out_verified_user
      user = ::User.find_by_id(params[:user_id])
      if user && user.verified? && signed_out?
        redirect_to login_url
      end
    end

    def forbid_missing_token
      if params[:token].blank?
        raise ActionController::Forbidden, "missing token"
      end
    end

    def forbid_non_existent_user
      unless ::User.find_by_id_and_verification_token(
                    params[:user_id], params[:token])
        raise ActionController::Forbidden, "non-existent user"
      end
    end
    
end
