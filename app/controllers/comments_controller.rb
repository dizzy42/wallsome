class CommentsController < ApplicationController
  
  def index
    @comments = Comment.all_for_todo_item_id(params[:todo_item_id])
    respond_to do |format|
      format.js { render :partial => "index", :layout => false }
    end
  end
  
  def create
    comment = Comment.new(params[:comment])
    comment.author_name = current_person.name_for_display(false)
    comment.created_at = Time.now
    if comment.save_for_todo_item_id(params[:todo_item_id])
      render :partial => "comment", :layout => false, :locals => { :comment => comment }
    else
      head 400
    end
  end
  
end
