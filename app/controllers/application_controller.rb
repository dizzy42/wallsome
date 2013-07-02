class ApplicationController < ActionController::Base
  Forbidden = Class.new(StandardError)
  NoCurrentAccount = Class.new(StandardError)

  protect_from_forgery

  before_filter :authenticate

  around_filter :recover_from_ssl_changes_to_basecamp_accounts
  around_filter :cache_resource_requests
  around_filter :set_resource_site_and_user

  rescue_from "ActiveResource::UnauthorizedAccess",        :with => :recover_from_bad_api_token
  rescue_from "ApplicationController::UnauthorizedAccess", :with => :recover_from_bad_api_token
  rescue_from "ApplicationController::NoCurrentAccount",   :with => :recover_from_no_current_account
  rescue_from "ActiveResource::ForbiddenAccess",           :with => :recover_from_api_not_enabled

  layout "logged_in" # default, override in logged out controllers/actions

  protected

    def cache_resource_requests
      ActiveResource::Connection.use_cache = true
      begin
        yield
      ensure
        ActiveResource::Connection.use_cache = false
        ActiveResource::Connection.clear_cache
        BasecampResourceIdentityMap::Base.clear_all_caches
      end
    end

    def set_resource_site_and_user
      raise NoCurrentAccount unless current_account
      BasecampResource.site_for_all_subclasses = current_account.url
      BasecampResource.user_for_all_subclasses = current_api_token
      begin
        yield
      ensure
        BasecampResource.site_for_all_subclasses = nil
        BasecampResource.user_for_all_subclasses = nil
      end
    end

    def signed_in?
      !current_user.nil?
    end
    helper_method :signed_in?

    def signed_out?
      current_user.nil?
    end
    helper_method :signed_out?

    def current_account
      return nil unless params[:basecamp_account_name]
      @_current_account ||= current_user.basecamp_accounts.find_by_name(params[:basecamp_account_name])
    end
    helper_method :current_account

    def current_project
      return nil unless params[:project_id]
      @_current_project ||= Project.find(params[:project_id])
    end
    helper_method :current_project

    def current_person
      Person.find(:one, :from => "/me")
    end
    helper_method :current_person

    def current_api_token
      return nil unless current_account
      current_user.api_token_for(current_account)
    end
    helper_method :current_api_token

    def current_basecamp_user
      current_user.basecamp_users.where(:basecamp_account_id => current_account.id).first
    end
    helper_method :current_basecamp_user

    def current_user
      @_current_user ||= user_from_cookie
    end
    helper_method :current_user

    def current_user=(user)
      @_current_user = user
    end

    def authenticate
      deny_access unless signed_in?
    end

    def sign_in(user)
      if user
        cookies[:remember_token] = {
          :value => user.remember_token,
          :expires => 1.year.from_now.utc
        }
        self.current_user = user
      end
    end

    def sign_out
      current_user.reset_remember_token! if current_user
      cookies.delete(:remember_token)
      self.current_user = nil
    end

    def deny_access(flash_message = nil)
      redirect_to login_url
    end

    def user_from_cookie
      if token = cookies[:remember_token]
        ::User.find_by_remember_token(token)
      end
    end

    def redirect_to_root
      redirect_to root_url
    end

    def redirect_to_signed_in_root
      redirect_to basecamp_accounts_url
    end

    def recover_from_ssl_changes_to_basecamp_accounts
      tries = 0
      begin
        tries += 1
        yield
      rescue ActiveResource::Redirection => e
        if tries <= 3 && current_account && current_account.update_attribute(:is_ssl, !current_account.is_ssl)
          retry
        else
          Rails.logger.error "Attempting to update ssl setting for current_user: #{current_user.id} failed"
        end
      end
    end

    def recover_from_bad_api_token
      flash[:error] = <<-MSG
        We couldn't access your Basecamp Account.
        You probably have a bad API Token.
        Please update it.
      MSG
      redirect_to edit_basecamp_user_url(current_basecamp_user)
    end

    def recover_from_no_current_account
      flash[:error] = <<-MSG
        Sorry but, we couldn't access your Basecamp Account: #{params[:basecamp_account_name]}.
        The account name may have been changed in basecamp.
        Please update it here.
      MSG
      redirect_to basecamp_users_url
    end

    def recover_from_api_not_enabled
      flash[:error] = <<-MSG
        Sorry but, we couldn't access your Basecamp Account: #{params[:basecamp_account_name]}.
        You may not have enabled the api. This can be done in Basecamp, by the account owner.
      MSG
      redirect_to basecamp_users_url
    end

    # Helpers for urls that live in the wallsome website, not the app
    def faq_url
      WALLSOME_SITE_BASE_URL + "/faq.html"
    end
    helper_method :faq_url

    def contact_url
      WALLSOME_SITE_BASE_URL + "/contact.html"
    end
    helper_method :contact_url

    def getting_started_url
      WALLSOME_SITE_BASE_URL + "/getting_started.html"
    end
    helper_method :getting_started_url

    def todo_lists_as_json(todo_lists, milestone = nil)
      todo_lists.sort { |a, b| b.position <=> a.position }.map do |list|
        {
          :id              => list.id,
          :name            => list.name,
          :description     => list.description,
          :completed       => list.completed,
          :position        => list.position,
          :milestone_id    => list.milestone_id,
          :milestone_title => milestone && milestone.title.truncate(40),
          :project_id      => list.project_id,
          :todo_items      => list.items_for_view
        }
      end.to_json
    end
end
