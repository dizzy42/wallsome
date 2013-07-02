module ProjectsHelper
  
  def project_milestones_based_on_switch(project)
    params[:show_completed_milestones] ? project.milestones : project.not_completed_milestones
  end
  
  def switch_between_not_completed_and_all_milestones_link
    if params[:show_completed_milestones]
      link_to "Not Completed Milestones", projects_path(:basecamp_account_name => current_account.name)
    else
      link_to "Show All Milestones", projects_path(:show_completed_milestones => true, :basecamp_account_name => current_account.name)
    end
  end
end
