class MilestonesController < ApplicationController
  layout 'project'
  rescue_from "ActiveResource::ResourceNotFound", :with => :recover_from_resource_not_found

  def index
    @filter = (params[:filter] || "uncompleted").to_sym
    if @filter == :uncompleted
      @milestones = current_project.not_completed_milestones
    else
      @milestones = current_project.milestones.try(:reverse)
    end
    flash.now[:notice] = "Please create a milestone" if @milestones.empty?
  end

  def current
    ActiveRecord::Base.include_root_in_json = false
    @milestone = current_project.current_milestone
    if @milestone.nil?
      redirect_to project_milestones_url(:basecamp_account_name => current_account.name,
                                         :project_id => current_project.id)
    else
      @todo_lists_json = todo_lists_json
      @columns_json = ProjectColumn.all(:project_id => current_project.id).to_json

      respond_to do |format|
        format.html { render :show_kanban }
        format.json { render :json => @milestone.to_json }
      end
    end
    ActiveRecord::Base.include_root_in_json = true
  end

  def show
    ActiveRecord::Base.include_root_in_json = false
    # This might be optimizable, perhaps we do not need to get it from the current_project ??
    @milestone = current_project.milestone(params[:id])
    if @milestone.nil?
      flash[:error] = "The milestone you selected does not exist."
      redirect_to project_milestones_url(:basecamp_account_name => current_account.name, :project_id => current_project.id)
    end
    @todo_lists_json = todo_lists_json
    @columns_json = ProjectColumn.all(:project_id => current_project.id).to_json
    ActiveRecord::Base.include_root_in_json = true

    render :show_kanban
  end

  def new
    @milestone = Milestone.new(:project_id => params[:project_id],
                               :title => "",
                               :deadline => Date.today)
  end

  def create
    @milestone = Milestone.new
    @milestone.title = params[:milestone][:title]
    @milestone.deadline = params[:milestone][:deadline]

    if @milestone.valid? && @milestone = @milestone.create_single(current_project)
      redirect_to project_milestone_url(:project_id => current_project.id,
                                        :id => @milestone.id,
                                        :basecamp_account_name => current_account.name)
    else
      render :action => "new"
    end
  end

  def edit
    @milestone = current_project.milestone(params[:id])
  end

  def update
    @milestone = current_project.milestone(params[:id])
    @milestone.title = params[:milestone][:title]
    @milestone.deadline = params[:milestone][:deadline]
    if @milestone.update
      flash[:notice] = "Milestone edited"
      redirect_to project_milestone_url(:project_id => current_project.id,
                                        :id => @milestone.id,
                                        :basecamp_account_name => current_account.name)
    else
      flash[:error] = "Milestone edit failed"
      render :action => 'edit'
    end
  end

  def destroy
    milestone = current_project.milestone(params[:id])
    if milestone.destroy
      flash[:notice] = "Milestone deleted"
    else
      flash[:error] = "Milestone could not be deleted"
    end
    redirect_to projects_url(:basecamp_account_name => current_account.name)
  end

  private

    def recover_from_resource_not_found
      flash[:error] = "Sorry we could not find the project"
      redirect_to projects_url(:basecamp_account_name => current_account.name)
    end

    def todo_lists_json
      todo_lists_as_json(@milestone.todo_lists, @milestone)
    end
end
