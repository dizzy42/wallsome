class MoveTodoItem

  def self.create(project, params)
    item   = TodoItem.find(params[:id])
    column = ProjectColumn.find(params[:column_id], project)
    move = new(project, item, column)
    move.save
  end

  attr_reader :item
  def initialize(project, item, column)
    @project     = project
    @item        = item
    @column      = column
  end

 def save
   @item.column = column
 end

end
