class ProjectsController < ApplicationController
  
  rescue_from "ActiveResource::ResourceNotFound", :with => :redirect_to_basecamp_users
  
  def index
    @projects = Project.all_functional
    flash.now[:notice] = "You do not have any active projects. Create one in Basecamp, and come back." if @projects.empty?
  end
  
  private
  
    def redirect_to_basecamp_users
      flash[:error] = "Your Basecamp Account: #{params[:basecamp_account_name]} could not be found.  Please check the name."
      redirect_to basecamp_users_url
    end
  
end
