class BacklogsController < ApplicationController
  layout 'project'
  
  def show
    @filter = (params[:filter] || "unassigned").to_sym
    @todo_lists_json = todo_lists_as_json(if @filter == :all
      current_project.todo_lists
    elsif @filter == :uncompleted
      current_project.todo_lists(:uncompleted)
    else
      current_project.todo_lists(:unassigned)
    end)
  end
end
