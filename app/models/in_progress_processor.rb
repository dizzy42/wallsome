class InProgressProcessor

  IN_PROGRESS_REGEXP = /\*in progress\*$/

  def initialize(items, project_id)
    @items      = items
    @project_id = project_id
  end

  def save
    move_to_in_progress_column
    remove_in_progress_marker
  end

  private

  def move_to_in_progress_column
    if try_to_move_to_in_progress_column?
      @items.each do |item|
        TodoItemColumn.create(:todo_item_id => item.id, :custom_column_id => in_progress_column.id) if in_progress?(item)
      end
    end
  end

  def try_to_move_to_in_progress_column?
    !!in_progress_column
  end

  def remove_in_progress_marker
    @items.each do |item|
      unset_in_progress_marker(item) if marked_in_progress?(item)
    end
  end

  def in_progress_column
    return @in_progress_column unless @in_progress_column.nil?
    ProjectColumn.all(:project_id => @project_id)
    @in_progress_column = CustomColumn.where(:project_id => @project_id, :name => "In Progress", :position => 1).first
  end

  def project
    @project ||= Project.find(@project_id)
  end

  def unset_in_progress_marker(item)
    item.content.gsub!(IN_PROGRESS_REGEXP, '')
    item.content.strip!
    item.save
  end

  def in_progress?(item)
    !item.completed? && marked_in_progress?(item)
  end

  def marked_in_progress?(item)
    item.content =~ IN_PROGRESS_REGEXP
  end

end
