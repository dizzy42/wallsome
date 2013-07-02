class ProjectColumn

  def self.completed
    new(:id       => "completed",
        :name     => "Completed",
        :position => 10_000,
        :editable => false)
  end

  def self.open
    new(:id       => "open",
        :name     => "Open",
        :position => 0,
        :editable => false)
  end

  def self.find(id, project)
    if id == "open"
      open
    elsif id == "completed"
      completed
    else
      CustomColumn.where(:project_id => project.id).where(:id => id).first
    end
  end

  def self.find_for_item(item)
    if todo_item_column = TodoItemColumn.where(:todo_item_id => item.id).first
      todo_item_column.custom_column
    elsif item.completed?
      ProjectColumn.completed # id => "completed"
    else
      ProjectColumn.open # id => "open"
    end
  end

  def self.all(params)
    if custom_columns(params).empty?
      CustomColumn.create(params.merge(:name => "In Progress", :position => 1))
    end
    [open, custom_columns(params), completed].flatten
  end

  attr_reader :id, :name, :position
  def initialize(attributes)
    @id       = attributes[:id]
    @name     = attributes[:name]
    @position = attributes[:position]
  end

  def add_item(item)
    item.todo_item_column && item.todo_item_column.destroy
    id == "completed" ? item.complete : item.uncomplete
  end

  def destroy
    true
  end

  private

  def self.custom_columns(params)
    CustomColumn.where(params).order("position").all
  end

end
