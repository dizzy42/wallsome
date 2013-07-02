class ColumnsController < ApplicationController
  layout 'project'

  def edit
    @columns = CustomColumn.where(:project_id => current_project.id).order("position").all
  end

  def update
    CustomColumn.order_columns(:project_id         => current_project.id,
                               :ordered_column_ids => params[:ordered_column_ids].split(","))

    redirect_to edit_project_columns_path(:basecamp_account_name => current_account.name, :project_id => current_project.id),
                :notice => "Columns updated"
  end

end
