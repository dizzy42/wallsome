class Comment < BasecampResource
  schema do
    string  'body'
  end
  
  def self.all_for_todo_item_id(todo_item_id)
    all(:from => "/todo_items/#{todo_item_id}/comments")
  end
  
  def save_for_todo_item_id(todo_item_id)
    request_body = "<request>" + self.to_xml(:skip_instruct => true) + "</request>"
    response = connection.post("/todo_items/#{todo_item_id}/comments",
                    request_body,
                    XML_REQUEST_HEADERS)
    self
  end
end