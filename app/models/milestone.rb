class Milestone < BasecampResource
  include ActiveModel::Validations

  validates_presence_of :title

  # This method exists because the milestone API is still not RESTFUL
  # Instead of returning an id, like the others, it returns an array of 1 object,
  # the complete milestone
  # ActiveResource doesn't know what to do with it, so we have to manually convert it
  # to a milestone object and return it
  def create_single(project)
    request_body = "<request>" + self.to_xml(:skip_instruct => true) + "</request>"
    response = connection.post("/projects/#{project.id}/milestones/create",
                    request_body,
                    XML_REQUEST_HEADERS)
    load(self.class.format.decode(response.body).first)
  end

  def title_for_display(account)
    return nil unless title
    if account.id == 2030
      title.sub(/\[Est: .*\]/, "").strip
    else
      title
    end
  end

  def todo_lists
    project.todo_lists.select { |list| list.milestone_id == id }
  end

  def <=>(other_milestone)
    deadline.to_time <=> other_milestone.deadline.to_time
  end

  def destroy
    connection.post("/milestones/delete/#{id}",
                    "",
                    XML_REQUEST_HEADERS)
  end

  def update
    connection.post("/milestones/update/#{id}",
                    to_xml,
                    XML_REQUEST_HEADERS)
  end

  def project
    Project.find(project_id)
  end
end
