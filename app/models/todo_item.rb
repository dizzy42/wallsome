class TodoItem < BasecampResource

  # Define the attributes needed for new instances.
  # Otherwise they are unknown before the schema has been loaded from the API.
  schema do
    string  'content'
    integer 'completer_id'
    string  'responsible_party'
    string  'responsible_party_type'
    integer 'responsible_party_id'
    integer 'comments_count'
  end

  def completer
    return nil unless completer_id
    BasecampResourceIdentityMap::Person.find(completer_id)
  end

  def responsible_party_as_object
    return nil unless responsible_party_id && responsible_party_type
    "BasecampResourceIdentityMap::#{responsible_party_type}".constantize.find(responsible_party_id)
  rescue NameError => e
    Rails.logger.info e.inspect
    nil
  end

  # def content_for_display
  #   return nil unless content
  #   if current_acccount.id == 2030
  #     content.sub(/\[EST: .*\]/, "").strip
  #   else
  #     content
  #   end
  # end

  def collection_path
    "/todo_lists/#{todo_list_id}/todo_items.xml"
  end

  def completed?
    completed
  end

  def column
    ProjectColumn.find_for_item(self)
  end

  def todo_item_column
    TodoItemColumn.where(:todo_item_id => id).first
  end

  def uncomplete
    completed = false
    save
    put(:uncomplete)
  end

  def complete
    completed = true
    save
    put(:complete)
  end

end
