class CustomColumn < ActiveRecord::Base
  has_many :todo_item_columns, :dependent => :destroy

  def self.order_columns(params)
    position = 1
    delete_missing_columns(params)
    params[:ordered_column_ids].each do |column_id|
      set_column_position(params[:project_id], column_id, position)
      position += 1
    end
  end


  def add_item(item)
    item.todo_item_column && item.todo_item_column.destroy
    todo_item_columns.create(:todo_item_id => item.id)
    item.uncomplete
  end

  private

  def self.delete_missing_columns(params)
    column_ids = params[:ordered_column_ids].empty? ? [-1] : params[:ordered_column_ids]
    columns_table = CustomColumn.arel_table
    columns = CustomColumn.where(:project_id => params[:project_id]).
      where(columns_table[:id].not_in(column_ids)).
      destroy_all
  end

  def self.set_column_position(project_id, column_id, position)
    column = CustomColumn.where(:id => column_id).first
    column ||= CustomColumn.new(:name => column_id, :project_id => project_id)
    column.position = position
    column.save
  end
end
