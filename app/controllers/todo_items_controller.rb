class TodoItemsController < ApplicationController

  respond_to :json

  def create
    # this could build an item on the todolist, but this should work for now
    item = TodoItem.new(params[:todo_item])
    item.todo_list_id = params[:todo_list_id]

    if item.save
      render :json => item
    else
      head 400
    end
  end

  def update
    item = TodoItem.find(params[:id])
    item.content = params[:todo_item][:content]
    item.responsible_party = params[:todo_item][:responsible_party]

    if item.save
      render :json => item
    else
      head 400
    end
  end

  # Use generic move action, instead of open, in_progress, completed, because we cannot
  # easily distinguish what the users intent is, without smart frontend code
  def move
    item = TodoItem.find(params[:id])
    todo_list = TodoList.find(params[:todo_list_id])
    column = ProjectColumn.find(params[:todo_item][:column_id], todo_list.milestone.project)
    column.add_item(item)

    # ReorderTodoItems.create(params)
    if should_reorder_or_reparent_item?(item, column)
      todo_list = TodoList.find(params[:todo_list_id])
      # this 'reparents' a todo item to a new todo list and reorders
      todo_list.reorder_items(ordered_todo_item_ids)
    end

    # store activity of our users, to get an idea of how much people are really using wallsome
    activity = TodoItemActivity.new
    activity.user_id = current_user.id
    activity.basecamp_account_id = current_account.id
    activity.save

    render :json => item
  rescue ActiveResource::ResourceNotFound
    head 404
  end

  def destroy
    item = TodoItem.find(params[:id])
    if item.destroy
      render :nothing => true
    else
      head 400
    end
  end

  def dialog
    project = Project.find(params[:project_id])
    respond_to do |format|
      format.js do
        render :partial => 'todo_items/dialog', :locals => { :project => project }, :layout => false
      end
    end
  end

  private

    def ordered_todo_item_ids
      ids = []
      params[:ordered_todo_item_ids].each do |k, v|
        ids[k.to_i] = v
      end
      ids
    end

    def should_reorder_or_reparent_item?(item, column)
      column.id != "completed" || item.todo_list_id != params[:todo_list_id]
    end
end
