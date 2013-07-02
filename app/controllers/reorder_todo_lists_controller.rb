class ReorderTodoListsController < ApplicationController
  layout 'project'

  def edit
    if params[:milestone_id]
      @milestone = current_project.milestone(params[:milestone_id])
      @cancel_link = project_milestone_path(current_project, @milestone, :basecamp_account_name => current_account.name)
    else
      @cancel_link = project_backlog_path(:basecamp_account_name => current_account.name,
                                          :project_id => current_project.id,
                                          :filter => params[:filter])
    end
    @todo_lists = todo_lists
  end

  def update
    current_project.reorder_todo_lists(params[:ordered_list_ids].split(",")) unless params[:ordered_list_ids].empty?
    flash[:notice] = "Reordered Todo Lists"
    if milestone_list_reordering?
      redirect_to project_milestone_path(current_project,
                                         current_project.milestone(params[:milestone_id]),
                                        :basecamp_account_name => current_account.name)
    else
      redirect_to project_backlog_path(current_project, :basecamp_account_name => current_account.name, :filter => params[:filter])
    end
  end

  private

    def milestone_list_reordering?
      params[:milestone_id]
    end

    def todo_lists
      if params[:milestone_id]
        @milestone.todo_lists
      elsif params[:filter] && params[:filter] == "all"
        current_project.todo_lists(:uncompleted) + current_project.todo_lists(:completed)
      elsif params[:filter] && params[:filter] == "uncompleted"
        current_project.todo_lists(:uncompleted)
      else
        current_project.todo_lists(:unassigned)
      end
    end

end
