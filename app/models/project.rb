class Project < BasecampResource

  def self.all_functional
    all.try(:select) { |p| p.status != "archived" } || []
  end

  def milestones
    Milestone.find(:all, :from => "/projects/#{id}/milestones/list").try(:sort)
  end

  def milestone(id)
    milestones.try(:detect) { |m| m.id == id.to_i }
  end

  def current_milestone
    not_completed_milestones.sort.first
  end

  def not_completed_milestones
    milestones.select { |m| !m.completed? }
  end

  def companies
    Company.all(:from => "/projects/#{id}/companies").sort
  end

  def people
    Person.all(:from => "/projects/#{id}/people").sort
  end

  def completed?
    completed
  end

  def todo_lists(filter=nil)
    case filter
    when :uncompleted : uncompleted_todo_lists
    when :unassigned  : uncompleted_and_unassigned_todo_lists
    when :completed   : completed_todo_lists
    else all_todo_lists
    end
  end

  def reorder_todo_lists(ordered_list_ids)
    return true if ordered_list_ids.empty?
    ordered_list_ids_as_xml = "<todo-lists type='array'>"
    ordered_list_ids.each do |id|
      ordered_list_ids_as_xml << "<todo-list><id>#{id}</id></todo-list>"
    end
    ordered_list_ids_as_xml << "</todo-lists>"

    connection.post("/projects/#{id}/todo_lists/reorder.xml",
                    ordered_list_ids_as_xml,
                    XML_REQUEST_HEADERS)
  end

  private

    def all_todo_lists
      TodoList.find(:all, :from => "/projects/#{id}/todo_lists")
    end

    def uncompleted_todo_lists
      TodoList.find(:all, :from => "/projects/#{id}/todo_lists?filter=pending")
    end

    def uncompleted_and_unassigned_todo_lists
      uncompleted_todo_lists.select { |l| l.milestone_id.nil? }
    end

    def completed_todo_lists
      TodoList.find(:all, :from => "/projects/#{id}/todo_lists?filter=finished")
    end
end
