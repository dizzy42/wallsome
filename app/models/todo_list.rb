class TodoList < BasecampResource
  # Define the attributes needed for new instances.
  # Otherwise they are unknown before the schema has been loaded from the API.
  schema do
    string  'name'
    string  'description'
    integer 'milestone_id'
  end

  def items
    return [] if new?
    items = TodoItem.find(:all, :from => "/todo_lists/#{id}/todo_items")
    InProgressProcessor.new(items, project_id).save
    items
  end

  # i know, but give me a break for now
  def items_for_view
    items.sort_by { |i| i.position }.map do |item|
      {
        :id                     => item.id,
        :content                => item.content,
        :responsible_party_name => item.responsible_party_as_object.try(:name_for_display),
        :responsible_party_id   => item.responsible_party_as_object.try(:responsible_party_id),
        :column_id              => item.column.id,
        :num_comments           => item.comments_count || 0
      }
    end
  end

  def milestone
    milestone_id && project_id && Project.find(project_id).milestones.select { |m| m.id == milestone_id }.first
  end

  def collection_path
    "/projects/#{project_id}/todo_lists.xml"
  end

  def reorder_items(ordered_item_ids)
    xml_string = "<todo-items type='array'>"
    ordered_item_ids.each do |item_id|
      xml_string << "<todo-item><id>#{item_id}</id></todo-item>"
    end
    xml_string << "</todo-items>"

    connection.post("/todo_lists/#{id}/todo_items/reorder.xml",
                    xml_string,
                    XML_REQUEST_HEADERS)

  end

  # Could not get the general save to work yet,
  # manual PUT request as a temporary workaround
  def update
    connection.put("/todo_lists/#{id}.xml",
                   "<todo-list>
                      <name>#{name}</name>
                      <description>#{description}</description>
                      <milestone_id>#{milestone_id}</milestone_id>
                    </todo-list>",
                   XML_REQUEST_HEADERS)
  end

  def completed?
    items.present? && items.all? { |i| i.completed? }
  end

end
