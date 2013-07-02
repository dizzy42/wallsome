class TodoListsController < ApplicationController

  def create
    todo_list = TodoList.new(params[:todo_list])
    todo_list.project_id = params[:project_id]
    todo_list.milestone_id = params[:milestone_id] if params[:milestone_id]
    if todo_list.save
      render :json => todo_list
    else
      # is this really the best way??
      head 400
    end
  end

  def update
    todo_list = TodoList.find(params[:id])
    todo_list.name = params[:todo_list][:name]
    todo_list.description = params[:todo_list][:description]
    todo_list.milestone_id = params[:todo_list][:milestone_id] if params[:todo_list][:milestone_id]
    todo_list.update

    render :json => todo_list
  end

  def destroy
    list = TodoList.find(params[:id])
    if list.destroy
      render :nothing => true
    else
      head 400
    end
  end

  def dialog
    project = Project.find(params[:project_id])
    milestone = project.milestone(params[:milestone_id]) if params[:milestone_id]
    respond_to do |format|
      format.js do
        render :partial => 'todo_lists/dialog',
               :locals => { :project => project, :milestone => milestone },
               :layout => false
      end
    end
  end

end
